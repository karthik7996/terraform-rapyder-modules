resource "aws_ssm_parameter" "private_key_ssm_param" {
  name        = var.name
  type        = var.type
  value       = var.value
  overwrite   = true
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