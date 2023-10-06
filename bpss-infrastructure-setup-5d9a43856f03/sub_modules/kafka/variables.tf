variable "name" {}
variable "project" {}
variable "env" {}
variable "location" {}
variable "product" {}

variable "cluster_name" {}
variable "kafka_version" {}
variable "number_of_broker_nodes" {}
variable "instance_type" {}
variable "subnet_ids" {
  type = list(string)
}
variable "volume_size" {
  type = number
}
# monitoring
variable "jmx_exporter" {
  type = bool
}
variable "node_exporter" {
  type = bool
}
#variable "kafka_versions" {
#  type = list(string)
#}
variable "server_properties" {}
variable "cidr_blocks" {
  type = list(string)
}
variable "protocol" {}
variable "inbound_ports" {
  type = list(number)
}
variable "vpc_id" {}