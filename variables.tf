variable "name" {
  description = "The name of the ALB"
  type        = string
}

variable "internal" {
  description = "If true, the ALB will be internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "The type of load balancer. Either 'application' or 'network'"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "The security groups to attach to the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets to attach to the ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "If true, deletion protection will be enabled"
  type        = bool
  default     = false
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port for the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "The protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "health_check_interval" {
  description = "The interval for health checks"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "The path for health checks"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "The protocol for health checks"
  type        = string
  default     = "HTTP"
}

variable "health_check_timeout" {
  description = "The timeout for health checks"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "The number of healthy checks before considering the target healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "The number of unhealthy checks before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
