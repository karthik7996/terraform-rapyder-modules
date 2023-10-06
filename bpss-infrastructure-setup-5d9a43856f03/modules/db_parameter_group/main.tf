resource "aws_db_parameter_group" "db_parameter_group" {
  name   = var.name
  family = var.family
#  dynamic "parameter" {
#    for_each = ""
#    content {
#      name = ""
#      value = ""
#    }
#  }
#  parameter {
#    name  = "character_set_server"
#    value = "utf8"
#  }
#  parameter {
#    name  = "character_set_client"
#    value = "utf8"
#  }
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