terraform {
  backend "s3" {
    bucket  = ""
    key     = "prod/ezedox.tfstate"
    region  = ""
    encrypt = true
  }
}