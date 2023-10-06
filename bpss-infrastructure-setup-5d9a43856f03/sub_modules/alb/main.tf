module "alb_sg" {
  source        = "../../modules/security_group_deprecated"
  description   = "security group for alb"
  name          = "${var.name}-alb-sg"
  env           = var.env
  project       = var.project
  product       = var.product
  location      = var.location
  vpc_id        = var.vpc_id
  inbound_ports = [80, 443]
  protocol      = "tcp"
}

module "alb" {
  source                     = "../../modules/alb"
  name                       = "${var.name}-alb"
  env                        = var.env
  project                    = var.project
  product                    = var.product
  location                   = var.location
  enable_deletion_protection = var.enable_deletion_protection
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.alb_sg.security_group_id]
  subnets                    = var.subnets
}

module "alb_listener" {
  source            = "../../modules/alb_listener"
  name              = "${var.name}-alb"
  env               = var.env
  project           = var.project
  product           = var.product
  location          = var.location
  load_balancer_arn = module.alb.alb_arn
  port              = "80"
  protocol          = "HTTP"
  ssl_policy        = null
  certificate_arn   = null
}

module "alb_https_listener" {
  source            = "../../modules/alb_https_listener"
  name              = "${var.name}-https-alb"
  env               = var.env
  project           = var.project
  product           = var.product
  location          = var.location
  load_balancer_arn = module.alb.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
}