module "db_subnet_group" {
  source     = "../../modules/db_subnet_group"
  name       = "${var.name}-db-sg"
  env        = var.env
  location   = var.location
  project    = var.project
  subnet_ids = var.subnet_ids
}

module "db_parameter_group" {
  source   = "../../modules/db_parameter_group"
  name     = "${var.name}-db-pg"
  env      = var.env
  location = var.location
  project  = var.project
  family   = var.family
}

module "db_security_group" {
  source = "../../modules/security_group"
  name               = "${var.name}-rds-sg"
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

module "random_password" {
  source = "../../modules/random_password"
}

module "db-ssm" {
  source   = "../../modules/ssm_parameter"
  name     = "/${var.name}/db/password"
  project  = var.project
  env      = var.env
  location = var.location
  type     = "SecureString"
  value    = module.random_password.password
}

module "db_instance" {
  source               = "../../modules/db_instance"
  name                 = "${var.name}-db"
  db_name              = var.db_name
  env                  = var.env
  location             = var.location
  project              = var.project
  allocated_storage    = var.allocated_storage
  db_subnet_group_name = module.db_subnet_group.db_subnet_group_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  multi_az             = var.multi_az
  parameter_group_name = module.db_parameter_group.db_paramter_group_name
  username             = var.username
  password             = module.random_password.password
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [module.db_security_group.security_group_id]
#  replica              = var.replica
}