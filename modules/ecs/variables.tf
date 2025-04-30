# Variables
variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
}

variable "task_family" {
  description = "Family of the ECS task definition"
  type        = string
}

variable "cpu" {
  description = "CPU allocation for the ECS task"
  type        = string
}

variable "memory" {
  description = "Memory allocation for the ECS task"
  type        = string
}

variable "container_name" {
  description = "Docker image for the container"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_cpu" {
  description = "Container-level CPU allocation"
  type        = string
}

variable "container_memory" {
  description = "Container-level memory allocation"
  type        = string
}

variable "memory_reservation" {
  description = "Memory reservation for the container"
  type        = string
}

variable "container_port" {
  description = "Port for the container"
  type        = number
}

variable "subnet_ids" {
  description = "Subnets for the ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for the ECS service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN for the ECS service"
  type        = string
}

