module "vpc_setup" {
  source = "./modules/vpc"
  
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  allowed_ssh_cidr    = ["0.0.0.0/0"]
  allowed_http_cidr   = ["0.0.0.0/0"]
  allowed_https_cidr  = ["0.0.0.0/0"]
}

module "ecr_repo" {
  source              = "./modules/ecr"
  ecr_repository_name = "awfiz"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true
  scan_on_push         = true

  ecr_tags = {
    Name        = "awfiz"
    Environment = "staging"
  }
}

# Call the ALB module
module "alb" {
  source = "./alb_module"  # Path to the ALB module directory

  alb_name               = "awsfiz-alb"
  alb_internal           = false
  alb_security_groups    = ["sg-12345678", "sg-87654321"]  # Todo: call from VPC module
  alb_subnets            = ["subnet-abc123", "subnet-def456"]  # Todo: call from VPC module
  target_group_name      = "awfiz-tg"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = "vpc-12345678"  # Todo: call from VPC module
  target_group_health_check_path = "/"
  target_group_health_check_interval = 30
  target_group_health_check_timeout  = 5
  target_group_healthy_threshold   = 3
  target_group_unhealthy_threshold = 3
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "ecs_cluster" {
  source                     = ".modules/ecs"  # Path to the ecs_cluster module
  cluster_name               = "awfiz-cluster"
  ecs_task_execution_role_name = "awfiz-ecsTaskExecutionRole"
  task_family                = "awfiz_task"
  cpu                        = "512"
  memory                     = "1024"
  container_image            = "nginx:latest" # Todo add propertary image details
  container_cpu              = "256"
  container_memory           = "512"
  memory_reservation        = "256"
  container_port             = 80
  subnet_ids                 = ["subnet-abc123", "subnet-def456"] #Todo: call this from vpd module
  security_group_id          = "sg-0123456789abcdef"  #Todo: call this from vpc module
  target_group_arn           = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/my-target-group" #Todo: call this from alb module
}

