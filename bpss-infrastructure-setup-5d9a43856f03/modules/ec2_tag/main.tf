resource "aws_ec2_tag" "tags" {
  resource_id   = var.resource_id
  key           = var.key
  value         = var.value
}