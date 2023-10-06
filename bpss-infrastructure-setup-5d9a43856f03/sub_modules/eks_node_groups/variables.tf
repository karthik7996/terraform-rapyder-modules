variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "disk_size" {}
variable "capacity_type" {}
variable "subnet_ids" {
  type = list(string)
}
variable "cluster_name" {}
variable "instance_types" {
  type = list(string)
}

variable "key_name" {}
variable "image_id" {}
variable "additional_node_group_policies" {}
#variable "instance_type" {}
#variable "volume_size" {}
#variable "user_data" {}