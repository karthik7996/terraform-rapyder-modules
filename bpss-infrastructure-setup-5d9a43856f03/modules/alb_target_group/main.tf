resource "aws_alb_target_group" "alb_target_group" {
  name = var.name
  port = var.port
  protocol = var.protocol
  target_type = var.target_type
  vpc_id = var.vpc_id

#  health_check {
#    path                = var.hc_path
#    interval            = 30
#    timeout             = 10
#    healthy_threshold   = 3
#    unhealthy_threshold = 5
#    matcher             = "200-299"
#  }

  health_check {
    path                = var.hc_path
    interval            = var.hc_interval
    timeout             = var.hc_timeout
    healthy_threshold   = var.hc_healthy_threshold
    unhealthy_threshold = var.hc_unhealthy_threshold
    matcher             = var.hc_matcher
  }

  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = var.product
  }
  tags_all = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = var.product
  }
}