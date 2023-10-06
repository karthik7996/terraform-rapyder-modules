resource "aws_eks_addon" "example" {
  cluster_name         = var.cluster_name
  addon_name           = var.addon_name
  addon_version        = var.addon_version
  resolve_conflicts    = var.resolve_conflicts
  service_account_role_arn = var.service_account_role_arn
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
}
