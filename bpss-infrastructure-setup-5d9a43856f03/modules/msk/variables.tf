variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}


variable "cluster_name" {}
variable "kafka_version" {}
variable "number_of_broker_nodes" {}
variable "instance_type" {}
variable "subnets" {
  type = list(string)
}
variable "volume_size" {
  type = number
}
variable "security_groups_ids" {
  type = list(string)
}
variable "aws_kms_key_arn" {}

# monitoring
variable "jmx_exporter" {
  type = bool
}
variable "node_exporter" {
  type = bool
}
variable "msk_config_arn" {}