output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_target_group_arns" {
  description = "The ARNs of the target groups"
  value       = aws_lb_target_group.this[*].arn
}

output "alb_listener_arns" {
  description = "The ARNs of the listeners"
  value       = aws_lb_listener.this[*].arn
}
