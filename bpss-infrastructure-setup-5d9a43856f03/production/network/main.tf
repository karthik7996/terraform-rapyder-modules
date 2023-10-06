module "bp-vpc" {
  source               = "../../modules/virtual_private_cloud"
  name                 = "${var.name}-${var.short_location}-${var.env}-vpc"
  env                  = var.env
  location             = var.location
  project              = var.project
  cidr_block           = "10.21.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# private, public and db subnets
variable "types" {
  default = ["private","db","public"]
}
variable "subnet_range" {
  default = [0,12,60]
}
variable "newbits" {
  default = [2,4,6]
}

module "subnets" {
  source       = "../../modules/subnets"
  count        = length(var.types)
  name         = "${var.name}-${var.short_location}-${var.env}-subnets-${var.types[count.index]}"
  env          = var.env
  project      = var.project
  location     = var.location
  vpc_id       = module.bp-vpc.vpc_id
  cidr_block   = module.bp-vpc.vpc_cidr_block
  newbits      = var.newbits[count.index]
  subnet_range = var.subnet_range[count.index]
}

# internet gateway
module "internet_gateway" {
  source   = "../../modules/internet_gateway"
  name     = "${var.name}-${var.short_location}-${var.env}-ig"
  env      = var.env
  project  = var.project
  location = var.location
  vpc_id   = module.bp-vpc.vpc_id
}

# elastic ip
module "elastic_ip" {
  source   = "../../modules/elastic_ip"
  name     = "${var.name}-${var.short_location}-${var.env}-eip"
  env      = var.env
  project  = var.project
  location = var.location
  vpc      = true
}

# nat gateway
module "nat_gateway" {
  source        = "../../modules/nat_gateway"
  name          = "${var.name}-${var.short_location}-${var.env}-natgw"
  env           = var.env
  project       = var.project
  location      = var.location
  allocation_id = module.elastic_ip.elastic_id
  subnet_id     = module.subnets[2].subnet_id[0]
}

module "route_tables" {
  source         = "../../modules/route_table"
  count          = length(var.types)
  name           = "${var.name}-${var.short_location}-${var.env}-rt-${var.types[count.index]}"
  env            = var.env
  project        = var.project
  location       = var.location
  vpc_id         = module.bp-vpc.vpc_id
  cidr_block     = "0.0.0.0/0"
  type           = var.types[count.index]
  gateway_id     = module.internet_gateway.internet_gateway_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "rote_table_association" {
  source         = "../../modules/route_table_association"
  count          = length(var.types)
  route_table_id = module.route_tables[count.index].route_table_id[0]
  subnet_id      = module.subnets[count.index].subnet_id
}