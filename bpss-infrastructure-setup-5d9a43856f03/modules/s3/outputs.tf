output "s3" {
  value = aws_s3_bucket.bucket.bucket
}
output "s3_arn" {
  value = aws_s3_bucket.bucket.arn
}
output "s3_id" {
  value = aws_s3_bucket.bucket.id
}

output "s3_domain" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}