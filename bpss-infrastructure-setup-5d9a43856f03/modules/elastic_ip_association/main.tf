resource "aws_eip_association" "eip_association" {
  allocation_id = var.eip_id
  instance_id = var.instance_id
}