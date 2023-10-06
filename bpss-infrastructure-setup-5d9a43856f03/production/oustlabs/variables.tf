variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "short_location" {}
variable "product" {}

#variable "ami" {}
variable "bucket_name" {}
variable "db_product" {
  type = list(string)
}
variable "ec_product" {
  type = list(string)
}