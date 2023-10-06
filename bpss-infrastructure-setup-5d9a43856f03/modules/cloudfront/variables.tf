variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}
variable "product" {}

variable "enabled" {
  type = bool
}
variable "allowed_methods" {
  type = list(string)
}
variable "cached_methods" {
  type = list(string)
}
variable "min_ttl" {
  type = number
}
variable "default_ttl" {
  type = number
}
variable "max_ttl" {
  type = number
}

variable "domain_name" {}
variable "origin_id" {}
variable "restriction_type" {}
variable "default_root_object" {}
variable "aliases" {
  type = list(string)
}

variable "acm_certificate_arn" {}
variable "cloudfront_default_certificate" {
  type = bool
}
variable "viewer_protocol_policy" {}
variable "target_origin_id" {}