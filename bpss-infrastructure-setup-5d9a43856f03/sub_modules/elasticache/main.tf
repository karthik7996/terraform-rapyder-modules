module "ec_security_group" {
  source        = "../../modules/security_group"
  name          = "${var.name}-ec-sg"
  env           = var.env
  project       = var.project
  location      = var.location
  product       = var.product
  description   = "security group for ${var.name}"
  cidr_blocks   = var.cidr_blocks
  inbound_ports = var.inbound_ports
  protocol      = var.protocol
  vpc_id        = var.vpc_id
}

module "elasticache_pg" {
  source   = "../../modules/elasticache_parameter_group"
  name     = "${var.name}-pg"
  env      = var.env
  project  = var.project
  location = var.location
  product  = var.product
  family   = var.family
}

module "elasticache_subg" {
  source     = "../../modules/elasticache_subnet_group"
  name       = "${var.name}-subg"
  env        = var.env
  project    = var.project
  location   = var.location
  product    = var.product
  subnet_ids = var.subnet_ids
}

#module "elasticache" {
#  source               = "../../modules/elasticache"
#  name                 = var.name
#  env                  = var.env
#  project              = var.project
#  location             = var.location
#  product              = var.product
#  engine               = var.engine
#  node_type            = var.node_type
#  num_cache_nodes      = var.num_cache_nodes
#  parameter_group_name = module.elasticache_pg.pg_name
#  engine_version       = var.engine_version
#  port                 = var.port
#  security_group_ids   = [module.ec_security_group.security_group_id]
#  subnet_group_name    = module.elasticache_subg.subnet_name
#  availability_zone    = var.availability_zone
#}

module "elasticache_rg" {
  source                      = "../../modules/elasticache_replication_group"
  name                        = var.name
  env                         = var.env
  project                     = var.project
  location                    = var.location
  product                     = var.product
  engine                      = var.engine
  engine_version              = var.engine_version
  automatic_failover_enabled  = true
  node_type                   = var.node_type
  num_cache_nodes_replicas    = var.num_cache_nodes_replicas
  parameter_group_name        = module.elasticache_pg.pg_name
  port                        = var.port
#  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  subnet_group_name           = module.elasticache_subg.subnet_name
  security_group_ids          = [module.ec_security_group.security_group_id]
  multi_az_enabled            = var.multi_az_enabled
  availability_zones          = var.availability_zones
}