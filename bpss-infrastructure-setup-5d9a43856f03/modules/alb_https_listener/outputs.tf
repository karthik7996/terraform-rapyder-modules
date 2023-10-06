output "alb_listener_id" {
  value = aws_lb_listener.alb_https_listener.id
}
output "alb_listener_arn" {
  value = aws_lb_listener.alb_https_listener.arn
}