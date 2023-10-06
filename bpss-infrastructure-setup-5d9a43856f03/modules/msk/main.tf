resource "aws_msk_cluster" "msk" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version #"3.2.0"
  number_of_broker_nodes = var.number_of_broker_nodes #3

  broker_node_group_info {
    instance_type = var.instance_type #"kafka.m5.large"
    client_subnets = var.subnets
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size #1000
      }
    }
    security_groups = var.security_groups_ids
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.aws_kms_key_arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter
      }
      node_exporter {
        enabled_in_broker = var.node_exporter
      }
    }
  }

  configuration_info {
    arn      = var.msk_config_arn
    revision = 1
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
