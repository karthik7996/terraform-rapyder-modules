variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "vpc_id" {}
variable "load_balancer_type" {}
variable "subnets" {
  type = list(string)
}
variable "internal" {
  type = bool
}
variable "enable_deletion_protection" {
  type = bool
}
variable "certificate_arn" {}