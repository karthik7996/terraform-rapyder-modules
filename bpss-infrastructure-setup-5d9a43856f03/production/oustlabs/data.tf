data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "bp-tf-statefile-bucket"
    key    = "frankfurt/prod/network.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "bp-tf-statefile-bucket"
    key    = "frankfurt/prod/common.tfstate"
    region = "us-east-1"
  }
}