variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "engine" {}
variable "engine_version" {}
variable "node_type" {}
variable "num_cache_nodes" {
  type = number
}
variable "parameter_group_name" {}
variable "port" {
  type = number
}
variable "security_group_ids" {
  type = list(string)
}
variable "subnet_group_name" {}
variable "availability_zone" {}