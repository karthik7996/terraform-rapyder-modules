output "msk_config_arn" {
  value = aws_msk_configuration.msk_config.arn
}

output "msk_server_properties" {
  value = aws_msk_configuration.msk_config.server_properties
}