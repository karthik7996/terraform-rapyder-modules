resource "aws_eks_cluster" "eks" {

  name     = var.name
  role_arn = var.role_arn
  version  = var.k8s_version

  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = var.security_group_ids
    subnet_ids              = var.subnet_ids
  }

  encryption_config {
#    resources = ["secrets"]
    resources = var.resources
    provider {
      key_arn = var.key_arn
    }
  }

  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }

  tags_all = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }

}