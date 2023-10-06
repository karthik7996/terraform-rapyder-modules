module "kms" {
  source                  = "../../modules/kms"
  name                    = "${var.name}-kafka-kms"
  env                     = var.env
  project                 = var.project
  location                = var.location
  product                 = var.product
  deletion_window_in_days = 30
}

module "msk_security_group" {
  source        = "../../modules/security_group"
  name          = "${var.name}-kafka-sg"
  env           = var.env
  project       = var.project
  location      = var.location
  product       = var.product
  description   = "security grpup for ${var.name}"
  cidr_blocks   = var.cidr_blocks
  inbound_ports = var.inbound_ports
  protocol      = var.protocol
  vpc_id        = var.vpc_id
}

module "msk_config" {
  source            = "../../modules/msk_config"
  name              = "${var.name}-kafka-config"
  kafka_versions    = [var.kafka_version]
  server_properties = var.server_properties
}

module "msk" {
  source                 = "../../modules/msk"
  cluster_name           = "${var.name}-kafka"
  name                   = "${var.name}-kafka"
  env                    = var.env
  project                = var.project
  location               = var.location
  product                = var.product
  kafka_version          = var.kafka_version
  instance_type          = var.instance_type
  number_of_broker_nodes = var.number_of_broker_nodes
  volume_size            = var.volume_size
  subnets                = var.subnet_ids
  security_groups_ids    = [module.msk_security_group.security_group_id]
  aws_kms_key_arn        = module.kms.kms_arn
  jmx_exporter           = var.jmx_exporter
  node_exporter          = var.node_exporter
  msk_config_arn         = module.msk_config.msk_config_arn
}