locals {
  cloudfront_vals = yamldecode(file("${path.module}/values.yaml")).cloudfront
}

module "cloudfront" {
  source                         = "../../sub_modules/cloudfront"
  for_each                       = { for i in local.cloudfront_vals : i.cdn => i }
  name                           = "${var.name}-${var.short_location}-${var.env}-${each.key}-cdn"
  env                            = var.env
  product                        = var.product
  location                       = var.location
  project                        = var.project
  bucket                         = each.value.bucket
  enabled                        = each.value.enabled
  default_root_object            = each.value.default_root_object
  aliases                        = each.value.aliases
  allowed_methods                = each.value.allowed_methods
  cached_methods                 = each.value.cached_methods
  default_ttl                    = each.value.default_ttl
  max_ttl                        = each.value.max_ttl
  min_ttl                        = each.value.min_ttl
  viewer_protocol_policy         = each.value.viewer_protocol_policy
  acm_certificate_arn            = each.value.acm_certificate_arn
  cloudfront_default_certificate = each.value.cloudfront_default_certificate
  restriction_type               = each.value.restriction_type
}