resource "aws_launch_template" "eks_launch_template" {
  name     = var.name
  key_name = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted   = true
      volume_size = var.volume_size
      volume_type = "gp3"
#      kms_key_id = var.kms_key_id
    }
  }
  #image_id      = "ami-0f8a7ce57b519af8b"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = var.user_data
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = var.name
      Project     = var.project
      Location    = var.location
      Environment = var.env
      Product     = var.product
    }
  }
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