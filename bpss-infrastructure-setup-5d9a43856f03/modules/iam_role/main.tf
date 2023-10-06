resource "aws_iam_role" "role" {
  name               = var.name
  description        = var.description
  assume_role_policy = var.assume_role_policy
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