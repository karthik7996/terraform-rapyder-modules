variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "subnet_ids" {
  type = list(string)
}