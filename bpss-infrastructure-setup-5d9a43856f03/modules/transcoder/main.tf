resource "aws_elastictranscoder_pipeline" "transcoder_pipeline" {
  name         = var.name
  input_bucket = var.input_bucket_id
  role         = var.role_arn

  content_config {
    bucket        = var.content_bucket_id
    storage_class = var.content_storage_class
  }

  thumbnail_config {
    bucket        = var.thumb_bucket_id
    storage_class = var.thumb_storage_class
  }
}