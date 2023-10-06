output "oidc_arn" {
  value = aws_iam_openid_connect_provider.default.arn
}

output "oidc_url" {
  value = aws_iam_openid_connect_provider.default.url
}

output "oidc_id" {
  value = aws_iam_openid_connect_provider.default.id
}