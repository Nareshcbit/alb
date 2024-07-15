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

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "target_groups" {
  description = "List of target groups"
  type = list(object({
    name                 = string
    port                 = number
    protocol             = string
    health_check_interval = number
    health_check_path     = string
    health_check_protocol = string
    health_check_timeout  = number
    healthy_threshold     = number
    unhealthy_threshold   = number
  }))
}

variable "target_ips" {
  description = "Map of target group names to lists of target IPs"
  type = map(list(string))
}

variable "listeners" {
  description = "List of listeners"
  type = list(object({
    port     = number
    protocol = string
  }))
}

variable "path_based_routing" {
  description = "List of path-based routing rules"
  type = list(object({
    listener_index = number
    priority       = number
    path_patterns  = list(string)
    target_group   = string
    weight         = number
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
