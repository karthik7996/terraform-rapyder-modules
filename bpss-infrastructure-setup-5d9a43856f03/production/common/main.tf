module "bp-common-kp" {
  source   = "../../sub_modules/key_pair"
  name     = "${var.name}-${var.short_location}-${var.env}"
  env      = var.env
  location = var.location
  product  = var.product
  project  = var.project
}

locals {
  vals = yamldecode(file("${path.module}/values.yaml")).instances
}

module "bp-common-ec2" {
  source        = "../../sub_modules/ec2"
  for_each      = { for i in local.vals : i.ec2 => i }
  name          = "${var.name}-${var.short_location}-${var.env}-${each.key}"
  env           = var.env
  location      = var.location
  project       = var.project
  product       = var.product
  key_name      = module.bp-common-kp.key_name
  vpc_id        = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  ami           = each.value.ami
  enable_eip    = each.value.enable_eip
  volume_size   = each.value.volume_size
  inbound_ports = each.value.inbound_ports
  cidr_blocks   = each.value.cidr_blocks
  protocol      = each.value.protocol
  instance_type = each.value.instance_type
  policy_arn    = each.value.policy_arn
  user_data     = each.value.user_data
}

module "bp-common-acm" {
  source            = "../../modules/acm"
  name              = "${var.name}-${var.short_location}-${var.env}-acm"
  env               = var.env
  location          = var.location
  project           = var.project
  product           = var.product
  domain_name       = "*.betterplace.tech"
  validation_method = "DNS"
}