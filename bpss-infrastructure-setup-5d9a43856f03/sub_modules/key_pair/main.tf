module "tls_key" {
  source   = "../../modules/tls_private_key"
  rsa_bits = 4096
}

locals {
  ssm_keypair        = ["private-key", "public-key", "public-key-openssh"]
  ssm_keypair_values = [module.tls_key.private_key_pem, module.tls_key.public_key_pem, module.tls_key.public_key_openssh]
}

module "bp-kp-ssm" {
  source   = "../../modules/ssm_parameter"
  count    = 3
  name     = "/${var.name}/${var.product}-ec2/${local.ssm_keypair[count.index]}"
  project  = var.project
  env      = var.env
  location = var.location
  type     = "SecureString"
  value    = local.ssm_keypair_values[count.index]
}

module "bp-kp" {
  source     = "../../modules/key_pair"
  name       = "${var.name}-${var.product}-kp"
  key_name   = "${var.name}-${var.product}-kp"
  project    = var.project
  env        = var.env
  location   = var.location
  public_key = module.tls_key.public_key_openssh
}
