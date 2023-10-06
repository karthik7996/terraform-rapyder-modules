terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.location
}

# Configure kubernetes Provider
provider "aws" {
  alias  = "eks"
  region = var.location
  assume_role {
    role_arn = "arn:aws:iam::443951760882:role/bp-sg-prod-hrms-eks-admin-role"
  }
}