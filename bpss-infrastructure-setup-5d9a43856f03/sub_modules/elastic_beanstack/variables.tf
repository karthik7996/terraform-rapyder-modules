variable "name" {}
variable "env" {}
variable "location" {}
variable "project" {}
variable "product" {}

#variable "bucket_name" {}
#variable "key_name" {}
variable "solution_stack_name" {}
variable "vpc_id" {}

variable "setting" {
  description = "list of values to assign to key values"
  type = list(object({
    name      = string
    namespace = string
    value     = string
  }))
}

variable "common_setting" {
  description = "list of values to assign to key values"
  type = list(object({
    name      = string
    namespace = string
    value     = string
  }))
}

variable "env_setting" {
  type = map(string)
}

variable "cidr_blocks" {
  type = list(string)
}
variable "inbound_ports" {
  type = list(number)
}
variable "protocol" {}
variable "ssh_restriction" {}
variable "policy_arn" {
  type = list(string)
}
