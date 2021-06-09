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
    resources = [replace(aws_ecs_task_definition.task[0].arn, "/:\\d+$/", ":*")]
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

resource "aws_ecs_task_definition" "task" {
  count                    = var.enable ? 1 : 0
  family                   = var.name
  execution_role_arn       = local.exec_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpus
  memory                   = var.memory
  container_definitions    = var.container_definitions
}
