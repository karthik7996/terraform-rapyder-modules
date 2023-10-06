output "domain" {
  value = aws_cloudfront_distribution.cfn.domain_name
}

output "aliases" {
  value = aws_cloudfront_distribution.cfn.aliases
}

output "cdn_id" {
  value = aws_cloudfront_distribution.cfn.id
}

output "cdn_arn" {
  value = aws_cloudfront_distribution.cfn.arn
}