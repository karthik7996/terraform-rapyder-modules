
resource "aws_elastic_beanstalk_application_version" "el_version" {
  application = var.application
  bucket      = var.bucket_id
  key         = var.key_id
  name        = var.name
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