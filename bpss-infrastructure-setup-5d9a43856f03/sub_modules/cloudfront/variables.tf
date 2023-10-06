variable "name" {}
variable "env" {}
variable "project" {}
variable "location" {}
variable "product" {}

variable "bucket" {}

variable "enabled" {
  type = bool
}
variable "default_root_object" {}
variable "aliases" {
  type = list(string)
}
variable "allowed_methods" {
  type = list(string)
}
variable "cached_methods" {
  type = list(string)
}
variable "viewer_protocol_policy" {}
variable "min_ttl" {
  type = number
}
variable "default_ttl" {
  type = number
}
variable "max_ttl" {
  type = number
}
variable "restriction_type" {}
variable "acm_certificate_arn" {}
variable "cloudfront_default_certificate" {
  type = bool
}