data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
locals {
  default_cluster_arn = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/default"
}

## These are defaults from terraform's documentation - they are required for cloudwatch to be able to trigger ecs tasks.
resource "aws_iam_role" "ecs_events" {
  count              = var.enable ? 1 : 0
  name               = "ecs_schedule_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_events.json
}

data "aws_iam_policy_document" "ecs_events" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ecs_events" {
  count = var.enable ? 1 : 0
  name  = "ecs_events_run_task_${var.name}"
  role  = aws_iam_role.ecs_events[0].name

  # This allows the cloudwatch rule to pass the default execution role to ECS to launch the task with.
  # The policy does not support the wildcard resource, you must give a specific role arn. The replace() syntax will wildcard the versions for the task definition.
  policy = data.aws_iam_policy_document.ecs_events_run_task.json
}

data "aws_iam_policy_document" "ecs_events_run_task" {
  statement {
    actions = [
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["ecs:RunTask"]
    resources = [var.enable ? replace(aws_ecs_task_definition.task[0].arn, "/:\\d+$/", ":*") : ""]
  }
}

resource "aws_cloudwatch_event_target" "target" {
  count     = var.enable ? 1 : 0
  target_id = var.name
  arn       = element(compact([var.cluster_arn, local.default_cluster_arn]), 0)
  rule      = var.cloudwatch_rule
  role_arn  = aws_iam_role.ecs_events[0].arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.task[0].arn
    launch_type         = "FARGATE"

    network_configuration {
      subnets = var.subnets
    }
  }
}

locals {
  region = length(var.region) > 0 ? var.region : data.aws_region.current.name
  environ = [
    for key in sort(keys(var.environment)) : {
      name  = key
      value = var.environment[key]
    }
  ]

  secrets = [
    for key in sort(keys(var.secrets)) : {
      name      = key
      valueFrom = substr(var.secrets[key], 0, 8) == "arn:aws:" ? var.secrets[key] : substr(var.secrets[key], 0, 4) == "key/" ? "arn:aws:kms:${local.region}:${data.aws_caller_identity.current.account_id}:${var.secrets[key]}" : substr(var.secrets[key], 0, 1) == "/" ? "arn:aws:ssm:${local.region}:${data.aws_caller_identity.current.account_id}:parameter/${replace(var.secrets[key], "/^[/]/", "")}" : "arn:aws:secretsmanager:${local.region}:${data.aws_caller_identity.current.account_id}:secret:${var.secrets[key]}"
    }
  ]
}
resource "aws_ecs_task_definition" "task" {
  count                    = var.enable ? 1 : 0
  family                   = var.name
  execution_role_arn       = var.exec_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = jsonencode([{
    name        = var.name
    image       = var.image
    essential   = true
    command     = split(" ", var.command)
    environment = local.environ
    secrets     = local.secrets
  }])
}
