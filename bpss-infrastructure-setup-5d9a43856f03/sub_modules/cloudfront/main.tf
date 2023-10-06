module "cdn_s3" {
  source   = "../../modules/s3"
  name     = "${var.name}-s3"
  env      = var.env
  project  = var.project
  location = var.location
  product  = var.product
  bucket   = var.bucket
}

module "cdn" {
  source   = "../../modules/cloudfront"
  name     = var.name
  env      = var.env
  project  = var.project
  location = var.location
  product  = var.product
  # geeneral
  enabled             = var.enabled
  default_root_object = var.default_root_object
  aliases             = var.aliases # list
  # default cache behaviour
  allowed_methods        = var.allowed_methods # list
  cached_methods         = var.cached_methods  # list
  target_origin_id       = module.cdn_s3.s3_id
  viewer_protocol_policy = var.viewer_protocol_policy
  min_ttl                = var.min_ttl
  default_ttl            = var.default_ttl
  max_ttl                = var.max_ttl
  # origin
  domain_name = module.cdn_s3.s3_domain
  origin_id   = module.cdn_s3.s3_id
  # geo restriction
  restriction_type = var.restriction_type
  # certificate
  acm_certificate_arn            = var.acm_certificate_arn
  cloudfront_default_certificate = var.cloudfront_default_certificate
}

#module "cdn_s3_policy" {
#  source = "../../modules/s3_bucket_policy"
#  bucket = module.cdn_s3.s3
#  policy = ""
#}