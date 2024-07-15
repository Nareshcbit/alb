# ALB Module

This module deploys an Application Load Balancer (ALB) along with multiple target groups, listeners, and security groups. It also supports path-based load balancing.

## Usage

```hcl
module "alb" {
  source = "./alb"

  name                   = "my-alb"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = ["sg-12345678"]
  subnets                = ["subnet-12345678", "subnet-87654321"]
  enable_deletion_protection = false

  vpc_id                 = "vpc-12345678"

  target_groups = [
    {
      name                 = "target-group-1"
      port                 = 80
      protocol             = "HTTP"
      health_check_interval = 30
      health_check_path     = "/"
      health_check_protocol = "HTTP"
      health_check_timeout  = 5
      healthy_threshold     = 3
      unhealthy_threshold   = 3
    },
    {
      name                 = "target-group-2"
      port                 = 80
      protocol             = "HTTP"
      health_check_interval = 30
      health_check_path     = "/"
      health_check_protocol = "HTTP"
      health_check_timeout  = 5
      healthy_threshold     = 3
      unhealthy_threshold   = 3
    }
  ]

  target_ips = {
    "target-group-1" = ["192.168.1.1", "192.168.1.2"]
    "target-group-2" = ["192.168.2.1", "192.168.2.2"]
  }

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
    {
      port     = 8080
      protocol = "HTTP"
    }
  ]

  path_based_routing = [
    {
      listener_index = 0
      priority       = 1
      path_patterns  = ["/app1/*"]
      target_group   = "target-group-1"
    },
    {
      listener_index = 0
      priority       = 2
      path_patterns  = ["/app2/*"]
      target_group   = "target-group-2"
    },
    {
      listener_index = 1
      priority       = 1
      path_patterns  = ["/app3/*"]
      target_group   = "target-group-1"
    },
    {
      listener_index = 1
      priority       = 2
      path_patterns  = ["/app4/*"]
      target_group   = "target-group-2"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
