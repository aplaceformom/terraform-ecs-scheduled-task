# Terraform ECS Schedule Task
Schedule an ECS task in CloudWatch using Terraform

## Usage

*various commands

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_events_run_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#input\_cloudwatch\_log\_group) | CloudWatch Log Group for ECS Scheduled Task. If not defined, name is used instead. | `string` | n/a | yes |
| <a name="input_cloudwatch_rule"></a> [cloudwatch\_rule](#input\_cloudwatch\_rule) | Cron or scheduled rule to use for the scheduled task | `string` | n/a | yes |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | Default ECS cluster ARN.  If not defined then cluster named `default' will be used.` | `string` | `""` | no |
| <a name="input_command"></a> [command](#input\_command) | Override default container command. | `string` | `""` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Fargate CPU time allocation | `number` | `256` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables to pass to container at launch. | `map` | `{}` | no |
| <a name="input_exec_role_arn"></a> [exec\_role\_arn](#input\_exec\_role\_arn) | Role to pull the container and push logs to CW. This is required for the FARGATE launch type, optional for EC2 | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | Container image to pull | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Fargate Memory size allication | `number` | `512` | no |
| <a name="input_name"></a> [name](#input\_name) | Name value to use for task related objects | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Environment variables to set from the secrets store at launch. | `map` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `list` | `[]` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Role that provides the security context that the container actually runs in. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
