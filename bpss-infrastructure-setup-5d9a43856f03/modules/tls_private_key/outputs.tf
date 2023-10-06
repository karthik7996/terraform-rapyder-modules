output "public_key_openssh" {
  value = tls_private_key.private_key.public_key_openssh
}
output "public_key_pem" {
  value = tls_private_key.private_key.public_key_pem
}
output "private_key_pem" {
  value = tls_private_key.private_key.private_key_pem
}