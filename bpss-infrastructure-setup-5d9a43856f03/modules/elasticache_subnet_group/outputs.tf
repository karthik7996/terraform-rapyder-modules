output "subnet_name" {
  value = aws_elasticache_subnet_group.cache_subnets.name
}

output "subnet_ids" {
  value = aws_elasticache_subnet_group.cache_subnets.id
}