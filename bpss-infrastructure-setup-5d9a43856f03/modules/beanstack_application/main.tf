resource "aws_elastic_beanstalk_application" "el_apps" {
  name        = var.name
  description = var.description
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
    ignore_changes = [tags,tags_all]
  }
}