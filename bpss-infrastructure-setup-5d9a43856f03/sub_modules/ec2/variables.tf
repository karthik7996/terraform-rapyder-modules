variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "ami" {}
variable "inbound_ports" {
  type = list(number)
}
variable "vpc_id" {}
variable "subnet_id" {}
variable "instance_type" {}
variable "volume_size" {}
variable "key_name" {}
variable "user_data" {}
variable "policy_arn" {
  type = list(string)
}

variable "enable_eip" {
  type = bool
}

variable "cidr_blocks" {
  type = list(string)
}
variable "protocol" {}