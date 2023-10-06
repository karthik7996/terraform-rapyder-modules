output "pg_arn" {
  value = aws_elasticache_parameter_group.cache_pg.arn
}

output "pg_name" {
  value = aws_elasticache_parameter_group.cache_pg.name
}