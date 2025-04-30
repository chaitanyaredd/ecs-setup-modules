# Define the Application Load Balancer
resource "aws_lb" "awfiz_alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.alb_subnets
}

# Define the Target Group for the ALB
resource "aws_lb_target_group" "awfiz_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  target_type = "ip"  # Set target type as 'ip' to use IP addresses as the target

  health_check {
    path                = var.target_group_health_check_path
    interval            = var.target_group_health_check_interval
    timeout             = var.target_group_health_check_timeout
    healthy_threshold   = var.target_group_healthy_threshold
    unhealthy_threshold = var.target_group_unhealthy_threshold
  }
}

# Define the Listener for the ALB
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.awfiz_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.awfiz_target_group.arn
  }
}

