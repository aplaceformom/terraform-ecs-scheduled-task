variable "enable" {
  type    = bool
  default = false
}

variable "exec_role_arn" {
  description = "Role to pull the container and push logs to CW. This is required for the FARGATE launch type, optional for EC2"
  type        = string
  default     = ""
}

variable "task_role_arn" {
  description = "Role that provides the security context that the container actually runs in."
  type        = string
  default     = ""
}

variable "cloudwatch_rule" {
  description = "Cron or scheduled rule to use for the scheduled task"
  type        = string
}

variable "cloudwatch_log_group" {
  description = "CloudWatch Log Group for ECS Scheduled Task. If not defined, name is used instead."
  type        = string
  default     = ""
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "cpus" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "cluster_arn" {
  description = "Default ECS cluster ARN.  If not defined then cluster named `default' will be used."
  type        = string
  default     = ""
}

variable "subnets" {
  type    = list
  default = []
}

variable "container_definitions" {}

variable "name" {
  description = "Name value to use for task related objects"
}

locals {
  region               = element(compact([var.region, var.cluster["region"]]), 0)
  exec_role_arn        = element(compact([var.exec_role_arn, var.cluster["execution_role_arn"]]), 0)
  cloudwatch_log_group = element(compact([var.cloudwatch_log_group, var.name]), 0)
}
