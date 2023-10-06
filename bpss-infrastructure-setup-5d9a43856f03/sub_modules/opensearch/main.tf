module "random_password" {
  source = "../../modules/random_password"
}

module "es-ssm" {
  source   = "../../modules/ssm_parameter"
  name     = "/${var.name}/es/password"
  project  = var.project
  env      = var.env
  location = var.location
  type     = "SecureString"
  value    = module.random_password.password
}

module "es_security_group" {
  source = "../../modules/security_group"
  name               = "${var.name}-es-sg"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "security group for ${var.name}"
  cidr_blocks        = var.cidr_blocks
  inbound_ports      = var.inbound_ports
  protocol           = var.protocol
  vpc_id             = var.vpc_id
}

module "es_domain" {
  source               = "../../modules/opensearch_domain"
  name                 = "${var.name}-es"
  env                  = var.env
  project              = var.project
  product              = var.product
  location             = var.location
  domain_name          = "${var.domain_name}-es"
  engine_version       = var.engine_version
  instance_type        = var.instance_type
  master_user_name     = var.master_user_name
  master_user_password = module.random_password.password
  security_group_ids   = [module.es_security_group.security_group_id]
  subnet_ids           = var.subnet_ids
}