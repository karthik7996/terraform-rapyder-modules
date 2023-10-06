resource "aws_elastic_beanstalk_environment" "el_environment" {
  application         = var.application
  name                = var.name
  solution_stack_name = var.solution_stack_name
#  version_label       = var.version_name

  #instance profile
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value     = var.instance_profile
  }

  # Security_Group
  setting {
    namespace      = "aws:autoscaling:launchconfiguration"
    name        = "SecurityGroups"
    value     = var.security_groups
  }

  # SSH Restriction
  setting {
    namespace      = "aws:autoscaling:launchconfiguration"
    name = "SSHSourceRestriction"
    value     = var.ssh_restriction
  }

  dynamic "setting" {
    for_each = var.setting
    iterator = item
    content {
      name      = item.value.name
      namespace = item.value.namespace
      value     = item.value.value
    }
  }

  # env's
  dynamic "setting" {
    for_each = var.env_setting
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

  dynamic "setting" {
    for_each = var.common_setting
    iterator = item
    content {
      name      = item.value.name
      namespace = item.value.namespace
      value     = item.value.value
    }
  }

  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = var.product
  }
  tags_all = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
    Product     = var.product
  }

  lifecycle {
    ignore_changes = [tags,tags_all]
  }

}