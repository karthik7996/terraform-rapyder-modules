variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "vpc_id" {}
variable "port" {
  type = number
}
variable "protocol" {}
variable "target_type" {}

# health check
variable "hc_path" {}
variable "hc_interval" {
  type = number
}
variable "hc_timeout" {
  type = number
}
variable "hc_healthy_threshold" {
  type = number
}
variable "hc_unhealthy_threshold" {
  type = number
}
variable "hc_matcher" {}
