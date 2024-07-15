module "alb" {
  source = "./alb"

  name                   = "my-alb"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = ["sg-12345678"]
  subnets                = ["subnet-12345678", "subnet-87654321"]
  enable_deletion_protection = false

  target_group_name      = "my-target-group"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = "vpc-12345678"
  target_ips             = ["192.168.1.1", "192.168.1.2"]

  health_check_interval  = 30
  health_check_path      = "/"
  health_check_protocol  = "HTTP"
  health_check_timeout   = 5
  healthy_threshold      = 3
  unhealthy_threshold    = 3

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
