output "target_group_name" {
  value = aws_alb_target_group.alb_target_group.name
}
output "target_group_id" {
  value = aws_alb_target_group.alb_target_group.id
}
output "target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}