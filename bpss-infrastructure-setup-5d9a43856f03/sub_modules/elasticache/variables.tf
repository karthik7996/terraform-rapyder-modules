variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "family" {}
variable "subnet_ids" {
  type = list(string)
}
variable "engine" {}
variable "node_type" {}
variable "num_cache_nodes" {
  type = number
}
variable "engine_version" {}
variable "port" {
  type = number
}

variable "inbound_ports" {
  type = list(string)
}
variable "protocol" {}
variable "cidr_blocks" {
  type = list(string)
}
variable "vpc_id" {}
variable "availability_zones" {
  type = list(string)
}
variable "num_cache_nodes_replicas" {}
variable "multi_az_enabled" {}
#variable "preferred_cache_cluster_azs" {
#  type = list(string)
#}