resource "aws_mq_configuration" "mq_config" {
  name           = var.name
  engine_type    = var.engine_type
  engine_version = var.engine_version

  data = var.data

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