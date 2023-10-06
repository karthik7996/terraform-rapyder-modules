module "transcoder_role" {
  source             = "../../modules/iam_role"
  name               = "${var.name}-transcoder-role"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  description        = "transcoder role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AmazonSNSFullAccess"]
}

module "transcoder_role_attach" {
  source = "../../modules/iam_role_policy_attachment"
  count = length(local.policies)
  role = module.transcoder_role.iam_role_name
  policy_arn = local.policies[count.index]
}

module "transcoder_s3" {
  source = "../../modules/s3"
  name               = "${var.name}-s3-transcoder"
  env                = var.env
  project            = var.project
  location           = var.location
  product            = var.product
  bucket             = var.bucket_name
}

module "transcoder" {
  source                = "../../modules/transcoder"
  name                  = "${var.name}-transcoder"
  role_arn              = module.transcoder_role.iam_role_arn
  input_bucket_id       = module.transcoder_s3.s3_id
  content_bucket_id     = module.transcoder_s3.s3_id
  content_storage_class = "Standard"
  thumb_bucket_id       = module.transcoder_s3.s3_id
  thumb_storage_class   = "Standard"
}