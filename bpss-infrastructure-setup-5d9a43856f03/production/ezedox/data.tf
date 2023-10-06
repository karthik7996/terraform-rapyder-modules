data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "bp-tf-statefile-ap-southeast-1"
    key    = "prod/common-resources.tfstate"
    region = "ap-southeast-1"
  }
}