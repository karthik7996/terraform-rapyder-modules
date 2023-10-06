module "bp-hrms-kp" {
  source   = "../../sub_modules/key_pair"
  name     = "${var.name}-${var.short_location}-${var.env}"
  env      = var.env
  location = var.location
  product  = "hrms"
  project  = var.project
}

locals {
  vals = yamldecode(file("${path.module}/values.yaml"))
}

#module "bp-hrms-ec2" {
#  source        = "../../sub_modules/ec2"
#  for_each      = { for i in local.vals : i.ec2 => i }
#  name          = "${var.name}-${var.short_location}-${var.env}-${each.key}"
#  env           = var.env
#  location      = var.location
#  project       = var.project
#  product       = var.product
#  key_name      = module.bp-hrms-kp.key_name
#  subnet_id     = data.terraform_remote_state.common.outputs.private_subnet_ids[0]
#  vpc_id        = data.terraform_remote_state.common.outputs.vpc_id
#  enable_eip    = each.value.enable_eip
#  volume_size   = each.value.volume_size
#  ami           = each.value.ami
#  inbound_ports = each.value.inbound_ports
#  instance_type = each.value.instance_type
#  policy_arn    = each.value.policy_arn
#  user_data     = null
#}


# Create eks
module "bp-hrms-eks" {
  source      = "../../sub_modules/eks"
  providers   = { aws = aws.eks }
  name        = "${var.name}-${var.short_location}-${var.env}-hrms"
  env         = var.env
  location    = var.location
  project     = var.project
  product     = var.product
  k8s_version = "1.27"
  subnet_ids  = data.terraform_remote_state.network.outputs.private_subnet_ids
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  # kube api-server security group specs
  cidr_blocks   = ["10.21.0.0/16"]
  protocol      = "tcp"
  inbound_ports = var.eks_inbound_ports
  # KMS resources
  resources = ["secrets"]
  # audit logs
  enabled_cluster_log_types = var.enabled_cluster_log_types
}

#module "bp-hrms-ng" {
#  source         = "../../sub_modules/node_groups"
#  providers      = { aws = aws.eks }
#  name           = "${var.name}-${var.short_location}-${var.env}-hrms"
#  env            = var.env
#  location       = var.location
#  project        = var.project
#  product        = var.product
#  capacity_type  = "ON_DEMAND"
#  cluster_name   = module.bp-hrms-eks.cluster_name
#  desired_size   = 3
#  disk_size      = 50
#  instance_types = ["r5a.xlarge"]
#  max_size       = 55
#  min_size       = 3
#  subnet_ids     = data.terraform_remote_state.common.outputs.private_subnet_ids
#}

module "bp-hrms-ng" {
  source         = "../../sub_modules/eks_node_groups"
  providers      = { aws = aws.eks }
  name           = "${var.name}-${var.short_location}-${var.env}-hrms"
  env            = var.env
  location       = var.location
  project        = var.project
  product        = var.product
  capacity_type  = "ON_DEMAND"
  cluster_name   = module.bp-hrms-eks.cluster_name
  instance_types = var.instance_types # ["r5a.xlarge"]
  image_id       = var.image_id
  max_size       = 55
  min_size       = 3
  desired_size   = 3
  disk_size      = 50
  key_name       = module.bp-hrms-kp.key_name
  subnet_ids     = data.terraform_remote_state.network.outputs.private_subnet_ids
  additional_node_group_policies = var.additional_node_group_policies
}

module "ebs_role_eks" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-${var.short_location}-${var.env}-hrms-ebs-addon-role"
  env                = var.env
  location           = var.location
  project            = var.project
  product            = var.product
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  description        = "ebs access for eks"
}

module "ebs_role_eks_attach" {
  source     = "../../modules/iam_role_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = module.ebs_role_eks.iam_role_name
}

#module "ebs_addon" {
#  source = "../../modules/eks_addons"
#  name           = "${var.name}-${var.short_location}-${var.env}-hrms-ebs-addon"
#  env            = var.env
#  location       = var.location
#  project        = var.project
#  product        = var.product
#  cluster_name = module.bp-hrms-eks.cluster_name
#  addon_name = "aws_eks_addon"
#  addon_version = "v1.18.0-eksbuild.1"
#  resolve_conflicts = "OVERWRITE"
#  service_account_role_arn = module.ebs_role_eks.iam_role_arn
#}

resource "aws_ec2_tag" "private" {
  count       = length(data.terraform_remote_state.network.outputs.private_subnet_ids)
  resource_id = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "public" {
  count       = length(data.terraform_remote_state.network.outputs.public_subnet_ids)
  resource_id = data.terraform_remote_state.network.outputs.public_subnet_ids[count.index]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

locals {
  all_subnets = concat(data.terraform_remote_state.network.outputs.private_subnet_ids, data.terraform_remote_state.network.outputs.public_subnet_ids)
}

resource "aws_ec2_tag" "common" {
  count       = length(local.all_subnets)
  resource_id = local.all_subnets[count.index]
  key         = "kubernetes.io/cluster/${var.name}-${var.short_location}-${var.env}-hrms-eks"
  value       = "owned"
}

module "bp-hrms-db" {
  source              = "../../sub_modules/rds"
  count               = 5
  name                = "${var.name}-${var.short_location}-${var.env}-${var.db_product[count.index]}"
  env                 = var.env
  location            = var.location
  project             = var.project
  product             = var.db_product[count.index]
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids          = data.terraform_remote_state.network.outputs.db_subnet_ids
  engine              = "postgres"
  engine_version      = "15.2"
  family              = "postgres15"
  allocated_storage   = 50
  db_name             = "demodb"
  inbound_ports       = [5432]
  instance_class      = "db.t3.micro"
  multi_az            = true
  protocol            = "tcp"
  skip_final_snapshot = true
  username            = "adminuser"
  cidr_blocks         = ["10.21.0.0/16"]
}


module "bp-hrms-msk" {
  source                 = "../../sub_modules/kafka"
  name                   = "${var.name}-${var.short_location}-${var.env}-hrms"
  cluster_name           = "${var.name}-${var.short_location}-${var.env}-hrms"
  env                    = var.env
  location               = var.location
  project                = var.project
  product                = "hrms"
  kafka_version          = "3.2.0"
  instance_type          = "kafka.t3.small"
  volume_size            = 50
  number_of_broker_nodes = "3"
  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids             = data.terraform_remote_state.network.outputs.db_subnet_ids
  cidr_blocks            = ["10.21.0.0/16"]
  protocol               = "tcp"
  inbound_ports          = [9092]
  jmx_exporter           = false
  node_exporter          = false
  server_properties      = <<PROPERTIES
auto.create.topics.enable=false
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
log.retention.hours=720
PROPERTIES
}

module "bp-hrms-ec" {
  source          = "../../sub_modules/elasticache"
  count           = length(var.ec_product)
  name            = "${var.name}-${var.short_location}-${var.ec_product[count.index]}"
  env             = var.env
  location        = var.location
  project         = var.project
  product         = var.ec_product[count.index]
  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.network.outputs.db_subnet_ids
  cidr_blocks     = ["10.21.0.0/16"]
  protocol        = "tcp"
  inbound_ports   = [6379]
  port            = 6379
  engine          = "redis"
  engine_version  = "7.0"
  family          = "redis7"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
  availability_zones = ["eu-central-1a","eu-central-1b"]
  multi_az_enabled = true
  num_cache_nodes_replicas = 2
}