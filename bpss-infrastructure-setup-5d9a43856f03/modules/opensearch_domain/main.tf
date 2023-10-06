resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain_name
  elasticsearch_version = var.engine_version

  cluster_config {
    instance_type = var.instance_type
  }

  vpc_options {
    security_group_ids = var.security_group_ids
    subnet_ids = var.subnet_ids
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }

  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name = var.master_user_name
      master_user_password = var.master_user_password
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
}


#resource "aws_opensearch_domain" "opensearch" {
#  domain_name    = var.domain_name
#  engine_version = var.engine_version
#
#  cluster_config {
#    instance_type = var.instance_type
#  }
#
#  vpc_options {
#    security_group_ids = var.security_group_ids
#    subnet_ids = var.subnet_ids
#  }
#
#  advanced_security_options {
#    enabled = true
#    master_user_options {
#      master_user_name = var.master_user_name
#      master_user_password = var.master_user_password
#    }
#  }
#
#  tags = {
#    Name        = var.name
#    Project     = var.project
#    Location    = var.location
#    Environment = var.env
#    Product     = var.product
#  }
#  tags_all = {
#    Name        = var.name
#    Project     = var.project
#    Location    = var.location
#    Environment = var.env
#    Product     = var.product
#  }
#}