module "ebs_security_group" {
  source = "../../modules/security_group"
  name               = "${var.name}-ebs-sg"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "security grpup for beanstack instance"
  cidr_blocks        = var.cidr_blocks
  inbound_ports      = var.inbound_ports
  protocol           = var.protocol
  vpc_id             = var.vpc_id
}

module "ebs_ec2_role" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-ebs-role"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "SSM role for ec2 instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
module "ebs_ec2_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count      = length(var.policy_arn)
  role       = module.ebs_ec2_role.iam_role_name
  policy_arn = var.policy_arn[count.index] #"arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

module "ebs_ec2_instance_profile" {
  source = "../../modules/instance_profile"
  name               = "${var.name}-ebs-role"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  role               = module.ebs_ec2_role.iam_role_name
}

module "ebs_apps" {
  source      = "../../modules/beanstack_application"
  name        = var.name
  description = "elastic beanstach apps for ${var.name}"
  env         = var.env
  location    = var.location
  project     = var.project
  product     = var.product
}

module "ebs_env" {
  source              = "../../modules/beanstack_environment"
  name                = var.name
  env                 = var.env
  location            = var.location
  project             = var.project
  product             = var.product
  security_groups     = module.ebs_security_group.security_group_id
  ssh_restriction     = var.ssh_restriction
  application         = module.ebs_apps.application_name
  solution_stack_name = var.solution_stack_name
  instance_profile    = module.ebs_ec2_instance_profile.instance_profile_name
  setting             = var.setting
  common_setting      = var.common_setting
  env_setting         = var.env_setting
}

#module "ebs_app_version" {
#  source      = "../../modules/beanstack_version"
#  name        = "${var.name}-apps"
#  description = "elastic beanstach apps for ${var.name}"
#  env         = var.env
#  location    = var.location
#  project     = var.project
#  product     = var.product
#  application = module.ebs_apps.application_name
#  bucket_id   = data.aws_s3_bucket.bucket.id
#  key_id      = data.aws_s3_object.object_id.id
#}
