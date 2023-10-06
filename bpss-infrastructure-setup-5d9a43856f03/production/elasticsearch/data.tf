data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "bp-tf-statefile-bucket"
    key    = "frankfurt/prod/network.tfstate"
    region = "us-east-1"
  }
}