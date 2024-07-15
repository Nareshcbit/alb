resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = each.value.health_check_interval
    path                = each.value.health_check_path
    protocol            = each.value.health_check_protocol
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for tg_name, ips in var.target_ips : "${tg_name}-${count.index}" => { tg_name = tg_name, ip = ips } }
  
  target_group_arn = aws_lb_target_group[each.value.tg_name].arn
  target_id        = each.value.ip
  port             = aws_lb_target_group[each.value.tg_name].port
}

resource "aws_lb_listener" "this" {
  for_each = { for listener in var.listeners : listener.port => listener }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "path_based_routing" {
  for_each = { for rule in var.path_based_routing : "${rule.listener_index}-${rule.priority}" => rule }

  listener_arn = aws_lb_listener.this[var.listeners[each.value.listener_index].port].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group[each.value.target_group].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = var.tags
}
