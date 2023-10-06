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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

module "node_group_role_attachment" {
  source     = "../../modules/iam_role_policy_attachment"
  count      = length(local.node_group_policies)
  policy_arn = local.node_group_policies[count.index]
  role       = module.node_group_role.iam_role_name
}

module "node_group" {
  source         = "../../modules/eks_node_group"
  name           = "${var.name}-ng"
  env            = var.env
  project        = var.project
  location       = var.location
  product        = var.product
  cluster_name   = var.cluster_name
  desired_size   = var.desired_size
  max_size       = var.max_size
  min_size       = var.min_size
  disk_size      = var.disk_size
  instance_types = var.instance_types
  node_role_arn  = module.node_group_role.iam_role_arn
  subnet_ids     = var.subnet_ids
  capacity_type  = var.capacity_type
}