resource "aws_alb_target_group_attachment" "tg_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = var.target_id
}