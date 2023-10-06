resource "aws_elasticache_parameter_group" "cache_pg" {
  name   = var.name
  family = var.family

#  parameter {
#    name  = "activerehashing"
#    value = "yes"
#  }
#
#  parameter {
#    name  = "min-slaves-to-write"
#    value = "2"
#  }

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