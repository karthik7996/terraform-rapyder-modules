data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "bp-tf-statefile-bucket"
    key    = "frankfurt/prod/network.tfstate"
    region = "us-east-1"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.bp-hrms-eks.cluster_openid_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [module.bp-hrms-eks.cluster_openid_arn]
      type        = "Federated"
    }
  }
}