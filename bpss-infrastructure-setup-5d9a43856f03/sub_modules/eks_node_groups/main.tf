# node group
module "node_group_role" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-ng-role"
  env                = var.env
  project            = var.project
  product            = var.product
  location           = var.location
  description        = "node group role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json
}
locals {
  node_group_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  ]
}

module "node_group_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count      = length(local.node_group_policies)
  policy_arn = local.node_group_policies[count.index]
  role       = module.node_group_role.iam_role_name
}

module "additional_node_group_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count = length(var.additional_node_group_policies)
  policy_arn = var.additional_node_group_policies[count.index]
  role       = module.node_group_role.iam_role_name
}

module "kms" {
  source                  = "../../modules/kms"
  name                    = "${var.name}-ng"
  env                     = var.env
  project                 = var.project
  location                = var.location
  product                 = var.product
  deletion_window_in_days = 30
}

module "node_group_lt" {
  source = "../../modules/launch_template"
  name           = "${var.name}-ng"
  env            = var.env
  project        = var.project
  location       = var.location
  product        = var.product
  key_name       = var.key_name
#  image_id       = "ami-0421a42914a257c5b"
  image_id       = var.image_id
  instance_type  = var.instance_types[0]
  volume_size    = var.disk_size
#  kms_key_id     = module.kms.kms_arn
  user_data      = base64encode(data.template_file.user_data_worker.rendered)
}

module "node_group" {
  source         = "../../modules/eks_nodegroup"
  name           = "${var.name}-ng"
  env            = var.env
  project        = var.project
  location       = var.location
  product        = var.product
  cluster_name   = var.cluster_name
  desired_size   = var.desired_size
  max_size       = var.max_size
  min_size       = var.min_size
#  disk_size      = var.disk_size
#  instance_types = var.instance_types
  node_role_arn  = module.node_group_role.iam_role_arn
  subnet_ids     = var.subnet_ids
  capacity_type  = var.capacity_type
  launch_template_name = module.node_group_lt.lt_name
  launch_template_version = module.node_group_lt.lt_version
}