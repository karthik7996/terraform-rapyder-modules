output "es_arn" {
  value = aws_elasticsearch_domain.es.arn
}

output "es_domain_name" {
  value = aws_elasticsearch_domain.es.domain_name
}

output "es_domain_id" {
  value = aws_elasticsearch_domain.es.domain_id
}

output "es_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}