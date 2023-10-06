output "alb_name" {
  value = module.alb.alb_name
}

output "alb_id" {
  value = module.alb.alb_id
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "alb_dns" {
  value = module.alb.alb_endpoint
}

output "alb_http_listener" {
  value = module.alb_listener.alb_listener_arn
}

output "alb_https_listener" {
  value = module.alb_https_listener.alb_listener_arn
}