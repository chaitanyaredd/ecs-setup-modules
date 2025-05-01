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
  source = "./modules/alb"  # Path to the ALB module directory

  alb_name               = "awsfiz-alb"
  alb_internal           = false
  alb_security_groups    = module.vpc_setup.security_group_id  # Call this from VPC module
  alb_subnets            = module.vpc_setup.public_subnet_ids  # Call this from VPC module
  target_group_name      = "awfiz-tg"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = module.vpc_setup.vpc_id  # Call this from VPC module
  target_group_health_check_path = "/"
  target_group_health_check_interval = 30
  target_group_health_check_timeout  = 5
  target_group_healthy_threshold   = 3
  target_group_unhealthy_threshold = 3
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "ecs_cluster" {
  source                     = "./modules/ecs"  # Path to the ecs_cluster module
  cluster_name               = "awfiz-cluster"
  ecs_task_execution_role_name = "awfiz-ecsTaskExecutionRole"
  task_family                = "awfiz_task"
  cpu                        = "512"
  memory                     = "1024"
  container_name             = "awfiz"
  container_image            = "nginx:latest" # Todo add propertary image details
  container_cpu              = "256"
  container_memory           = "512"
  memory_reservation        = "256"
  container_port             = 80
  subnet_ids                 = module.vpc_setup.public_subnet_ids # Call this from vpd module
  security_group_id          = module.vpc_setup.security_group_id  # Call this from vpc module
  target_group_arn           = module.alb.target_group_arn # Call this from ALB module
}

