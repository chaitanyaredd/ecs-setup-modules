# Define variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "alb_internal" {
  description = "Whether the ALB is internal or external"
  type        = bool
}

variable "alb_security_groups" {
  description = "Security group IDs for the ALB"
  type        = list(string)
}

variable "alb_subnets" {
  description = "Subnet IDs for the ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_group_health_check_path" {
  description = "Path for health check of the target group"
  type        = string
}

variable "target_group_health_check_interval" {
  description = "Interval (in seconds) between health checks"
  type        = number
}

variable "target_group_health_check_timeout" {
  description = "Timeout (in seconds) for health check"
  type        = number
}

variable "target_group_healthy_threshold" {
  description = "Healthy threshold for health check"
  type        = number
}

variable "target_group_unhealthy_threshold" {
  description = "Unhealthy threshold for health check"
  type        = number
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
}

