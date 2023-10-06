variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "solution_stack_name" {}
#variable "version_name" {}
variable "application" {}
variable "instance_profile" {}
#variable "target_group_arn" {}

variable "common_setting" {
  description = "list of values to assign to key values"
  type = list(object({
    name      = string
    namespace = string
    value     = string
  }))
}

variable "setting" {
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
variable "security_groups" {}
variable "ssh_restriction" {}