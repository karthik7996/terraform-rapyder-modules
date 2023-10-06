data "aws_iam_policy_document" "node_group_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "template_file" "user_data_worker" {
  template = file("${path.module}/user_data.sh")
  vars = {
    prefix = var.cluster_name
  }
}