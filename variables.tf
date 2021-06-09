variable "enable" {
  type    = bool
  default = true
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
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "image" {
  description = "Container image to pull"
  type        = string
}

variable "cpu" {
  description = "Fargate CPU time allocation"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate Memory size allication"
  type        = number
  default     = 512
}

variable "command" {
  description = "Override default container command."
  type        = string
  default     = ""
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

variable "environment" {
  description = "Environment variables to pass to container at launch."
  type        = map
  default     = {}
}

variable "secrets" {
  description = "Environment variables to set from the secrets store at launch."
  type        = map
  default     = {}
}

variable "name" {
  description = "Name value to use for task related objects"
  type        = string
}
