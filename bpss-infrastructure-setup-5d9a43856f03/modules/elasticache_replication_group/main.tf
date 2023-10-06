resource "aws_elasticache_replication_group" "erg" {
  automatic_failover_enabled  = var.automatic_failover_enabled
#  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  replication_group_id        = var.name
  node_type                   = var.node_type
  description                 = "ElastiCache Replication Group"
#  num_node_groups             = var.num_cache_nodes_replicas
  num_cache_clusters          = var.num_cache_nodes_replicas
  parameter_group_name        = var.parameter_group_name
  security_group_ids          = var.security_group_ids
  port                        = var.port
  engine                      = var.engine
  engine_version              = var.engine_version
  subnet_group_name = var.subnet_group_name
  availability_zones = var.availability_zones
  multi_az_enabled = var.multi_az_enabled
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

  lifecycle {
    ignore_changes = [num_node_groups]
  }

}