variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "vpc_id" {}
variable "description" {}
variable "inbound_ports" {
  type = list(number)
}
variable "protocol" {}
variable "cidr_blocks" {
  type = list(string)
}