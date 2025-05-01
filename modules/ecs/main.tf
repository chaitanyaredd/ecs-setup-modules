# Create ecs cluster
resource "aws_ecs_cluster" "fargate_cluster" {
  name = var.cluster_name
}

# --- IAM Role for ECS Task Execution ---
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# # --- ECS Task Definition ---
resource "aws_ecs_task_definition" "awfiz_task_def" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu    # Task-level CPU (0.5 vCPU)
  memory                   = var.memory   # Task-level Memory (1 GB)
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      cpu       = var.container_cpu               # Container-level CPU (0.25 vCPU)
      memory    = var.container_memory               # Hard limit (container killed if exceeded)
      memoryReservation = var.memory_reservation       # Soft limit (container starts here, can burst)
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# --- ECS Service ---
resource "aws_ecs_service" "awfiz_service" {
  name            = "awfiz_service"
  cluster         = aws_ecs_cluster.fargate_cluster.id  # Replace with your ECS cluster name
  task_definition = aws_ecs_task_definition.awfiz_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids  # Replace with actual subnet IDs
    assign_public_ip = true
    security_groups = var.security_group_id  # Replace with a valid security group
  }

  load_balancer {
    target_group_arn = var.target_group_arn  # Replace with your target group ARN
    container_name   = "awfiz"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}
