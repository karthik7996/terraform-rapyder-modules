variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "key_name" {}
variable "volume_size" {
  type = number
}
variable "image_id" {}
variable "instance_type" {}
variable "user_data" {}
#variable "kms_key_id" {}