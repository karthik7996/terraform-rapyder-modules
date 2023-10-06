resource "aws_kms_key" "kms" {
#  policy = var.policy
  deletion_window_in_days = var.deletion_window_in_days
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