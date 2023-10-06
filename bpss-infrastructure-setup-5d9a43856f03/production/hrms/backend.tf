terraform {
  backend "s3" {
    bucket  = "bp-tf-statefile-bucket"
    key     = "frankfurt/prod/hrms.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}