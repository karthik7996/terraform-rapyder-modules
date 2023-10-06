variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "node_type" {}
variable "num_cache_nodes_replicas" {
  type = number
}
variable "parameter_group_name" {}
variable "port" {
  type = number
}
variable "subnet_group_name" {}
#variable "preferred_cache_cluster_azs" {
#  type = list(string)
#}
variable "automatic_failover_enabled" {
  type = bool
}
variable "security_group_ids" {
  type = list(string)
}
variable "engine" {}
variable "engine_version" {}
variable "availability_zones" {
  type = list(string)
}
variable "multi_az_enabled" {}