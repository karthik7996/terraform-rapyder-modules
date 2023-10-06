variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "broker_name" {}
variable "engine_type" {}
variable "engine_version" {}
variable "host_instance_type" {}

variable "security_groups" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}

variable "username" {}
variable "password" {}