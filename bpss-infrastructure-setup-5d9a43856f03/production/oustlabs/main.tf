module "bp-oustlabs-kp" {
  source   = "../../sub_modules/key_pair"
  name     = "${var.name}-${var.short_location}-${var.env}"
  env      = var.env
  location = var.location
  product  = "oustlabs"
  project  = var.project
}

#locals {
#  vals = yamldecode(file("${path.module}/values.yaml")).instances
#}

#module "bp-oustlabs-ec2" {
#  source        = "../../sub_modules/ec2"
#  for_each      = { for i in local.vals : i.ec2 => i }
#  name          = "${var.name}-${var.short_location}-${var.env}-${each.key}"
#  ami           = each.value.ami
#  env           = var.env
#  product       = "oustlabs"
#  location      = var.location
#  project       = var.project
#  key_name      = module.bp-oustlabs-kp.key_name
#  subnet_id     = data.terraform_remote_state.common.outputs.private_subnet_ids[0]
#  vpc_id        = data.terraform_remote_state.common.outputs.vpc_id
#  enable_eip    = each.value.enable_eip
#  inbound_ports = each.value.inbound_ports
#  instance_type = each.value.instance_type
#  volume_size   = each.value.volume_size
#  policy_arn    = each.value.policy_arn
#  user_data     = null
#}


module "bp-oustlabs-alb" {
  source                     = "../../sub_modules/alb"
  name                       = "${var.name}-${var.short_location}-${var.env}-oustlabs"
  env                        = var.env
  product                    = "oustlabs"
  location                   = var.location
  project                    = var.project
  enable_deletion_protection = false
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = data.terraform_remote_state.common.outputs.public_subnet_ids
  vpc_id                     = data.terraform_remote_state.common.outputs.vpc_id
  certificate_arn            = data.terraform_remote_state.acm.outputs.acm_arn
}

locals {
  beanstack_vals = yamldecode(file("${path.module}/oustlabs_bs.yaml")).beanstack
}

module "bp-oustlabs-beanstack" {
  source              = "../../sub_modules/elastic_beanstack"
  for_each            = { for i in local.beanstack_vals : i.stack => i }
  name                = "${var.name}-${var.short_location}-${var.env}-${each.key}-bs"
  env                 = var.env
  product             = "oustlabs"
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
    { namespace = "aws:elbv2:loadbalancer", name = "SharedLoadBalancer", value = module.bp-oustlabs-alb.alb_arn },
    { namespace = "aws:elbv2:listener:80", name = "ListenerEnabled", value = "false" },
    { namespace = "aws:elbv2:listener:443", name = "ListenerEnabled", value = "true" },
    { namespace = "aws:autoscaling:launchconfiguration", name = "EC2KeyName", value = module.bp-oustlabs-kp.key_name }
  ]
}

#module "transcoder" {
#  source      = "../../sub_modules/transcoder"
#  name        = "${var.name}-${var.short_location}-${var.env}-oustlabs"
#  env         = var.env
#  product     = "oustlabs"
#  location    = var.location
#  project     = var.project
#  bucket_name = "${var.name}-${var.short_location}-${var.env}-oustlabs-transcoder"
#}

#locals {
#  cloudfront_vals = yamldecode(file("${path.module}/values.yaml")).cloudfront
#}

#module "cloudfront" {
#  source                         = "../../sub_modules/cloudfront"
#  for_each                       = { for i in local.cloudfront_vals : i.cdn => i }
#  name                           = "${var.name}-${var.short_location}-${var.env}-${each.key}-cdn"
#  env                            = var.env
#  product                        = "oustlabs"
#  location                       = var.location
#  project                        = var.project
#  bucket                         = each.value.bucket
#  enabled                        = each.value.enabled
#  default_root_object            = each.value.default_root_object
#  aliases                        = each.value.aliases
#  allowed_methods                = each.value.allowed_methods
#  cached_methods                 = each.value.cached_methods
#  default_ttl                    = each.value.default_ttl
#  max_ttl                        = each.value.max_ttl
#  min_ttl                        = each.value.min_ttl
#  viewer_protocol_policy         = each.value.viewer_protocol_policy
#  acm_certificate_arn            = each.value.acm_certificate_arn
#  cloudfront_default_certificate = each.value.cloudfront_default_certificate
#  restriction_type               = each.value.restriction_type
#}

module "bp-oustlabs-db" {
  source              = "../../sub_modules/rds"
  count               = length(var.db_product)
  name                = "${var.name}-${var.short_location}-${var.env}-${var.db_product[count.index]}"
  env                 = var.env
  location            = var.location
  project             = var.project
  product             = var.db_product[count.index]
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  subnet_ids          = data.terraform_remote_state.common.outputs.db_subnet_ids
  engine              = "mysql"
  engine_version      = "5.7"
  family              = "mysql5.7"
  allocated_storage   = 50
  db_name             = "demodb"
  inbound_ports       = [3306]
  instance_class      = "db.t3.medium"
  multi_az            = true
  protocol            = "tcp"
  skip_final_snapshot = true
  username            = "admin"
  cidr_blocks         = ["0.0.0.0/0"]
}

module "bp-oust-mq" {
  source             = "../../sub_modules/mq"
  name               = "${var.name}-${var.short_location}-${var.env}-oust"
  broker_name        = "${var.name}-${var.short_location}-${var.env}-oust"
  env                = var.env
  location           = var.location
  project            = var.project
  product            = "oustlabs"
  cidr_blocks        = ["10.21.0.0/16"]
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  inbound_ports      = [9092]
  protocol           = "tcp"
  vpc_id             = data.terraform_remote_state.common.outputs.vpc_id
  subnet_ids         = [data.terraform_remote_state.common.outputs.db_subnet_ids[0]]
  username           = "admin"
  data               = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA
}

module "bp-outslab-ec" {
  source          = "../../sub_modules/elasticache"
  count           = length(var.ec_product)
  name            = "${var.name}-${var.short_location}-${var.ec_product[count.index]}"
  env             = var.env
  location        = var.location
  project         = var.project
  product         = var.ec_product[count.index]
  vpc_id          = data.terraform_remote_state.common.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.common.outputs.db_subnet_ids
  cidr_blocks     = ["10.21.0.0/16"]
  protocol        = "tcp"
  inbound_ports   = [6379]
  port            = 6379
  engine          = "redis"
  engine_version  = "7.0"
  family          = "redis7"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
}