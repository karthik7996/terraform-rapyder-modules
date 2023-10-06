module "bp-hrms-es" {
  source           = "../../sub_modules/opensearch"
  count            = 2
  name             = "${var.name}-${var.short_location}-${var.env}-${var.product[count.index]}"
  domain_name      = "${var.name}-${var.short_location}-${var.env}-${var.product[count.index]}"
  env              = var.env
  location         = var.location
  project          = var.project
  product          = var.product[count.index]
  vpc_id           = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids       = [data.terraform_remote_state.network.outputs.db_subnet_ids[0]]
  cidr_blocks      = ["10.21.0.0/16"]
  inbound_ports    = [443]
  engine_version   = "7.10"
  instance_type    = "t3.small.elasticsearch"
  master_user_name = "admin"
  protocol         = "tcp"
}