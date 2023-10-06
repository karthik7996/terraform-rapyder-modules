variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "short_location" {}
variable "product" {}

variable "eks_inbound_ports" {}
variable "image_id" {}
variable "enabled_cluster_log_types" {
  type = list(string)
}
variable "instance_types" {
  type = list(string)
}
variable "db_product" {
  type = list(string)
}
variable "ec_product" {
  type = list(string)
}

variable "additional_node_group_policies" {
  type = list(string)
}