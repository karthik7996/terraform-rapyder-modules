output "alb_name" {
  value = aws_lb.alb.name
}
output "alb_id" {
  value = aws_lb.alb.id
}
output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_endpoint" {
  value = aws_lb.alb.dns_name
}