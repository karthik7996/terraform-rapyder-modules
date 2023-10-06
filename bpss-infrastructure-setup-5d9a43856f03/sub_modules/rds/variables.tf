variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "family" {}
variable "inbound_ports" {
  type = list(string)
}
variable "protocol" {}

variable "db_name" {}
variable "allocated_storage" {
  type = number
}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "multi_az" {
  type = bool
}

variable "username" {}
variable "skip_final_snapshot" {
  type = bool
}
variable "cidr_blocks" {
  type = list(string)
}
#variable "replica" {
#  type = bool
#}