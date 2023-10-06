resource "aws_s3_object" "obj" {
  bucket = var.bucket_id
  key    = var.key
  source = var.object_source
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