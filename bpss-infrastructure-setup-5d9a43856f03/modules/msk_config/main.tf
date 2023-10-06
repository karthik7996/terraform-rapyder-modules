resource "aws_msk_configuration" "msk_config" {
  kafka_versions = var.kafka_versions #["2.8.1"]
  name           = var.name
  server_properties = var.server_properties
}
