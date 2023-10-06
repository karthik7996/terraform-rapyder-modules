variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "enable_deletion_protection" {
  type = bool
}
variable "internal" {
  type = bool
}
variable "load_balancer_type" {}