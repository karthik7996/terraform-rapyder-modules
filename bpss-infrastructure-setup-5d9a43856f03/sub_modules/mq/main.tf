module "random_password" {
  source = "../../modules/random_password"
}

module "mq-ssm" {
  source   = "../../modules/ssm_parameter"
  name     = "/${var.name}/mq/password"
  project  = var.project
  env      = var.env
  location = var.location
  type     = "SecureString"
  value    = module.random_password.password
}

module "mq_security_group" {
  source = "../../modules/security_group"
  name               = "${var.name}-mq-sg"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "security grpup for ${var.name}"
  cidr_blocks        = var.cidr_blocks
  inbound_ports      = var.inbound_ports
  protocol           = var.protocol
  vpc_id             = var.vpc_id
}

module "mq_config" {
  source         = "../../modules/mq_config"
  name           = "${var.name}-mq-config"
  env            = var.env
  project        = var.project
  location       = var.location
  product        = var.product
  engine_type    = var.engine_type
  engine_version = var.engine_version
  data           = var.data
}

module "mq" {
  source             = "../../modules/mq"
  name               = "${var.name}-mq"
  broker_name        = "${var.broker_name}-mq"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  engine_type        = module.mq_config.mq_config_engine_type
  engine_version     = module.mq_config.mq_config_engine_version
  host_instance_type = var.host_instance_type
  username           = var.username
  password           = module.random_password.password
  security_groups    = [module.mq_security_group.security_group_id]
  subnet_ids         = var.subnet_ids
}