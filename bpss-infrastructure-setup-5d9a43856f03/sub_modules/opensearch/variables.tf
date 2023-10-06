variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "vpc_id" {}
variable "cidr_blocks" {
  type = list(string)
}
variable "inbound_ports" {
  type = list(string)
}
variable "protocol" {}

variable "domain_name" {}
variable "engine_version" {}
variable "instance_type" {}
variable "master_user_name" {}
variable "subnet_ids" {
  type = list(string)
}