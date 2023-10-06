variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "allocated_storage" {
  type = number
}
variable "db_name" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "username" {}
variable "password" {}
variable "parameter_group_name" {}
variable "multi_az" {}
variable "skip_final_snapshot" {
  type = bool
}
#variable "security_group_names" {
#  type = list(string)
#}
variable "db_subnet_group_name" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
#variable "replica" {
#  type = bool
#}
#variable "replicate_source_db" {}