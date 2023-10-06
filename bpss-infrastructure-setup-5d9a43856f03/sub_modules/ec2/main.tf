module "ec2_role" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-ec2-role"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "SSM role for ec2 instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
module "ec2_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count      = length(var.policy_arn)
  role       = module.ec2_role.iam_role_name
  #policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  policy_arn = var.policy_arn[count.index]
}

#module "sg" {
#  source        = "../../modules/security_group_deprecated"
#  description   = "security group"
#  name          = "${var.name}-sg"
#  env           = var.env
#  project       = var.project
#  product       = var.product
#  location      = var.location
#  vpc_id        = var.vpc_id
#  inbound_ports = var.inbound_ports
#  protocol      = "tcp"
#}

module "ec2_security_group" {
  source = "../../modules/security_group"
  name               = "${var.name}-ebs-sg"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "security grpup for ${var.name}"
  cidr_blocks        = var.cidr_blocks
  inbound_ports      = var.inbound_ports
  protocol           = var.protocol
  vpc_id             = var.vpc_id
}

module "ec2" {
  source          = "../../modules/ec2"
  name            = "${var.name}-ec2"
  project         = var.project
  env             = var.env
  location        = var.location
  product         = var.product
  ami             = var.ami
  role            = module.ec2_role.iam_role_name
  security_groups = [module.ec2_security_group.security_group_id]
  subnet_id       = var.subnet_id
  user_data       = var.user_data
  instance_type   = var.instance_type
  volume_size     = var.volume_size
  key_name        = var.key_name
}

module "eip" {
  source = "../../modules/elastic_ip"
  count    = var.enable_eip ? 1 : 0
  name     = "${var.name}-ec2-eip"
  env      = var.env
  project  = var.project
  location = var.location
  vpc      = true
}

module "eip_association" {
  source = "../../modules/elastic_ip_association"
  count  = var.enable_eip ? 1 : 0
  eip_id = module.eip.*.elastic_id[0]
  instance_id = module.ec2.instance_id
}