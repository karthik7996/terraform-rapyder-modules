module "bp-ezedox-kp" {
  source   = "../../sub_modules/key_pair"
  name     = "${var.name}-${var.short_location}-${var.env}"
  env      = var.env
  location = var.location
  product  = "ezedox"
  project  = var.project
}

locals {
  vals = yamldecode(file("${path.module}/values.yaml")).instances
}

module "bp-ezedox-ec2" {
  source        = "../../sub_modules/ec2"
  for_each      = { for i in local.vals : i.ec2 => i }
  name          = "${var.name}-${var.short_location}-${var.env}-${each.key}"
  ami           = each.value.ami
  env           = var.env
  location      = var.location
  project       = var.project
  product       = "ezedox"
  key_name      = module.bp-ezedox-kp.key_name
  vpc_id        = data.terraform_remote_state.common.outputs.vpc_id
  subnet_id     = data.terraform_remote_state.common.outputs.private_subnet_ids[0]
  enable_eip    = each.value.enable_eip
  volume_size   = each.value.volume_size
  inbound_ports = each.value.inbound_ports
  instance_type = each.value.instance_type
  policy_arn    = each.value.policy_arn
  user_data     = null
}

module "bp-ezedox-alb" {
  source                     = "../../sub_modules/alb"
  name                       = "${var.name}-${var.short_location}-${var.env}-ezedox"
  env                        = var.env
  product                    = "oustlabs"
  location                   = var.location
  project                    = var.project
  enable_deletion_protection = false
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = data.terraform_remote_state.common.outputs.public_subnet_ids
  vpc_id                     = data.terraform_remote_state.common.outputs.vpc_id
}

locals {
  beanstack_vals = yamldecode(file("${path.module}/ezedox_bs.yaml")).beanstack
}

module "bp-ezedox-beanstack" {
  source              = "../../sub_modules/elastic_beanstack"
  for_each            = { for i in local.beanstack_vals : i.stack => i }
  name                = "${var.name}-${var.short_location}-${var.env}-${each.key}-bs"
  env                 = var.env
  product             = "ezedox"
  location            = var.location
  project             = var.project
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  solution_stack_name = each.value.solution_stack_name
  setting             = each.value.setting
  env_setting         = each.value.env_setting
  cidr_blocks         = each.value.cidr_blocks
  inbound_ports       = each.value.inbound_ports
  protocol            = each.value.protocol
  ssh_restriction     = each.value.ssh_restriction
  policy_arn          = each.value.policy_arn
  common_setting = [
    { namespace = "aws:ec2:vpc", name = "VPCId", value = data.terraform_remote_state.common.outputs.vpc_id },
    { namespace = "aws:ec2:vpc", name = "Subnets", value = join(",", data.terraform_remote_state.common.outputs.private_subnet_ids) },
    { namespace = "aws:ec2:vpc", name = "ELBSubnets", value = join(",", data.terraform_remote_state.common.outputs.public_subnet_ids) },
    { namespace = "aws:elasticbeanstalk:healthreporting:system", name = "SystemType", value = "enhanced" },
    { namespace = "aws:elasticbeanstalk:environment", name = "EnvironmentType", value = "LoadBalanced" },
    { namespace = "aws:elasticbeanstalk:environment", name = "LoadBalancerType", value = "application" },
    { namespace = "aws:elasticbeanstalk:environment", name = "LoadBalancerIsShared", value = "True" },
    { namespace = "aws:elbv2:loadbalancer", name = "SharedLoadBalancer", value = module.bp-ezedox-alb.alb_arn },
    { namespace = "aws:elbv2:listener:80", name = "ListenerEnabled", value = "false" },
    { namespace = "aws:elbv2:listener:443", name = "ListenerEnabled", value = "true" },
    { namespace = "aws:autoscaling:launchconfiguration", name = "EC2KeyName", value = module.bp-ezedox-kp.key_name }
  ]
}

module "bp-ec2-alb-tg" {
  source                 = "../../modules/alb_target_group"
  name                   = "${var.name}-${var.short_location}-${var.env}-hireapp-tg"
  env                    = var.env
  product                = "ezedox"
  location               = var.location
  project                = var.project
  protocol               = "HTTP"
  target_type            = "instance"
  port                   = "80"
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  hc_healthy_threshold   = 3
  hc_interval            = 30
  hc_matcher             = "404"
  hc_path                = "/health"
  hc_timeout             = 10
  hc_unhealthy_threshold = 5
}

resource "aws_alb_listener_rule" "alb_hireapp_lister_rule" {
  depends_on = [module.bp-ezedox-beanstack]
  listener_arn = module.bp-ezedox-alb.alb_https_listener
  action {
    type = "forward"
    target_group_arn = module.bp-ec2-alb-tg.target_group_arn
  }
  condition {
    host_header {
      values = ["sg1-applicant-api.betterplace.tech"]
    }
  }
  tags = {
    Name        = "${var.name}-${var.short_location}-${var.env}-hireapp-alb-lr"
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = "ezedox"
  }
  tags_all = {
    Name        = "${var.name}-${var.short_location}-${var.env}-hireapp-alb-lr"
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = "ezedox"
  }
}

#module "bp-tg-attachment" {
#  source = "../../modules/alb_target_group_attachment"
#  target_group_arn = module.bp-ec2-alb-tg.target_group_arn
#  target_id = module.bp-ezedox-ec2.instance_id[0]
#}
