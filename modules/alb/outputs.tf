output "name" {
  value = aws_lb.awfiz_alb.name
  description = "The name of the ALB"
}

output "target_group_arn" {
  value = aws_lb_target_group.awfiz_target_group.arn
  description = "The ARN of the target group"
}