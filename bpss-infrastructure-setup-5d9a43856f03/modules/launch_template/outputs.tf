output "lt_name" {
  value = aws_launch_template.eks_launch_template.name
}
output "lt_id" {
  value = aws_launch_template.eks_launch_template.id
}
output "lt_arn" {
  value = aws_launch_template.eks_launch_template.arn
}
output "lt_version" {
  value = aws_launch_template.eks_launch_template.latest_version
}