#module "sg" {
#  source        = "../../modules/security_group_deprecated"
#  description   = "security group"
#  name          = "${var.name}-eks-sg"
#  env           = var.env
#  project       = var.project
#  location      = var.location
#  product       = var.product
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

module "eks_role" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-eks-role"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "kubernetes api-server role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy","arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}

module "eks_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count      = length(local.policies)
  policy_arn = local.policies[count.index]
  role       = module.eks_role.iam_role_name
}

module "kms" {
  source = "../../modules/kms"
  name                    = "${var.name}-eks"
  env                     = var.env
  project                 = var.project
  location                = var.location
  product                 = var.product
  deletion_window_in_days = 30
}

module "eks" {
  source                  = "../../modules/elastic_kubernetes_service"
  depends_on              = [module.eks_role_attachment]
  name                    = "${var.name}-eks"
  env                     = var.env
  project                 = var.project
  location                = var.location
  endpoint_private_access = true
  endpoint_public_access  = false
  k8s_version             = var.k8s_version #"1.25"
  role_arn                = module.eks_role.iam_role_arn
  security_group_ids      = [module.ec2_security_group.security_group_id]
  subnet_ids              = var.subnet_ids
  key_arn                 = module.kms.kms_arn
  resources               = var.resources #["secrets"]
  enabled_cluster_log_types = var.enabled_cluster_log_types
}

module "eks_openid" {
  source          = "../../modules/iam_openid_connect_provider"
  openid_url      = module.eks.cluster_openid_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.openid.certificates.0.sha1_fingerprint]
}
