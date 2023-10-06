output "mq_config_arn" {
  value = aws_mq_configuration.mq_config.arn
}

output "mq_config_engine_type" {
  value = aws_mq_configuration.mq_config.engine_type
}

output "mq_config_engine_version" {
  value = aws_mq_configuration.mq_config.engine_version
}