variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "vpc_id" {}
variable "inbound_ports" {
  type = list(number)
}
variable "subnet_ids" {
  type = list(string)
}

variable "k8s_version" {}
variable "resources" {
  type = list(string)
}

variable "cidr_blocks" {
  type = list(string)
}
variable "protocol" {}
variable "enabled_cluster_log_types" {
  type = list(string)
}