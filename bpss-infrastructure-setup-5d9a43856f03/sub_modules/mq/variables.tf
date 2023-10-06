variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "engine_type" {}
variable "engine_version" {}
variable "data" {}
variable "username" {}
variable "host_instance_type" {}
variable "broker_name" {}

variable "subnet_ids" {
  type = list(string)
}

variable "cidr_blocks" {
  type = list(string)
}
variable "inbound_ports" {
  type = list(string)
}
variable "protocol" {}
variable "vpc_id" {}