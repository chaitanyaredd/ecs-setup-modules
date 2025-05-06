---

## Overview

This document provides a comprehensive guide to deploying a Python Flask application to AWS ECS using Terraform. The deployment process is executed from an EC2 instance with an attached IAM role, eliminating the need for access and secret keys.

---

## Project Structure

### Root Directory
- **`app.py`**: A simple Flask application.
- **dockerfile**: Dockerfile to containerize the Flask application.
- **`main.tf`**: Terraform configuration to orchestrate modules for VPC, ECS, ECR, and ALB.
- **`provider.tf`**: Specifies the AWS provider and region.
- **`variables.tf`**: Defines global variables for the project.
- **`terraform.tfvars`**: Provides values for the variables.
- **`push_docker_image.sh`**: Bash script to build and push the Docker image to ECR.
- **`.github/workflows/deploy-to-ecs.yml`**: GitHub Actions workflow for CI/CD.
- **`requirements.txt`**: Python dependencies for the Flask application.
- **`.gitignore`**: Ignores Terraform state files and other sensitive files.

### Modules
#### **VPC Module**
- Creates a VPC, public subnets, route tables, and a security group.

#### **ECR Module**
- Creates an ECR repository.

#### **ECS Module**
- Creates an ECS cluster, task definition, and service.

#### **ALB Module**
- Creates an Application Load Balancer, target group, and listener.

---

## Required Tools Setup on EC2

To execute the deployment process from an EC2 instance, ensure the following tools are installed and configured:

1. **AWS CLI**
   ```sh
   sudo yum install aws-cli -y
   aws configure
   ```

2. **Terraform**
   ```sh
   sudo yum install -y yum-utils
   sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
   sudo yum install terraform -y
   ```

3. **Docker**
   ```sh
   sudo yum install docker -y
   sudo service docker start
   sudo usermod -aG docker $USER
   ```

4. **Git**
   ```sh
   sudo yum install git -y
   ```

5. **Python (Optional)**
   ```sh
   sudo yum install python3 -y
   sudo yum install python3-pip -y
   ```

---

## IAM Roles and Permissions

### EC2 Instance Role
Attach an IAM role to the EC2 instance with the following policies:
- `AmazonEC2ContainerRegistryFullAccess`
- `AmazonECS_FullAccess`
- `CloudWatchLogsFullAccess`
- `AmazonS3FullAccess` (if storing Terraform state files in S3)

### GitHub Actions Role
Create an IAM user for GitHub Actions with the following policies:
- `AmazonEC2ContainerRegistryFullAccess`
- `AmazonECS_FullAccess`
- `CloudWatchLogsFullAccess`

Generate an access key and secret key for this user and add them as GitHub secrets.

---

## Terraform Provider Configuration

In the provider.tf file, configure the AWS provider to use the IAM role attached to the EC2 instance:

```hcl
provider "aws" {
  region = var.aws_region
}
```

Terraform will automatically use the credentials provided by the instance metadata service.

---
### 1. VPC Module
The `vpc_setup` module creates the foundational networking infrastructure for your application. It includes:
- A **VPC** with the CIDR block `10.0.0.0/16`.
- Two **public subnets** with CIDR blocks `10.0.1.0/24` and `10.0.2.0/24`, spread across availability zones `us-east-1a` and `us-east-1b`.
- A **security group** that allows:
  - SSH access from `0.0.0.0/0` (open to all, but this should be restricted in production).
  - HTTP and HTTPS access from `0.0.0.0/0`.

The outputs of this module (VPC ID, subnet IDs, and security group ID) are used by other modules.

---

### 2. ECR Module
The `ecr_repo` module creates an **Elastic Container Registry (ECR)** repository named `awfiz`. This repository is used to store Docker images for your application.

Key features:
- **Immutable tags**: Ensures that once a tag is pushed, it cannot be overwritten.
- **Scan on push**: Automatically scans images for vulnerabilities when they are pushed to the repository.
- **Force delete**: Allows the repository to be deleted even if it contains images.

Tags like `Name` and `Environment` are added for better resource identification.

---

### 3. ALB Module
The `alb` module sets up an **Application Load Balancer (ALB)** to route traffic to your ECS service.

Key components:
- **ALB**: Internet-facing load balancer named `awsfiz-alb`.
- **Target Group**: Routes traffic to ECS tasks on port `80` using the `HTTP` protocol.
- **Health Checks**: Configured to check the health of ECS tasks at the path `/` every 30 seconds, with a timeout of 5 seconds.
- **Listener**: Listens for HTTP traffic on port `80` and forwards it to the target group.

The ALB uses the subnets and security group created by the VPC module.

---

### 4. ECS Module
The `ecs_cluster` module deploys your Flask application to an **ECS cluster**.

Key components:
- **ECS Cluster**: Named `awfiz-cluster`.
- **Task Definition**: Defines the containerized application with:
  - **Image**: Currently set to `nginx:latest` (you need to replace this with your proprietary image).
  - **CPU and Memory**: Allocates `512` CPU units and `1024` MB of memory for the task.
  - **Container Port**: Exposes port `80` for the application.
- **ECS Service**: Deploys the task to the cluster and integrates it with the ALB target group for traffic routing.

The ECS service uses the subnets and security group from the VPC module and the target group ARN from the ALB module.

---

## How It Works

1. **VPC Setup**: The `vpc_setup` module creates the networking infrastructure required for the application, including a VPC, subnets, and a security group.
2. **ECR Repository**: The `ecr_repo` module creates a repository to store Docker images for the application.
3. **Load Balancer**: The `alb` module sets up an Application Load Balancer to route traffic to the ECS service.
4. **ECS Deployment**: The `ecs_cluster` module deploys the application to an ECS cluster, using the Docker image stored in the ECR repository.
---

## Deployment Steps

### 1. **Setup Terraform**
- Initialize Terraform:
  ```sh
  terraform init
  ```
- Plan the infrastructure:
  ```sh
  terraform plan
  ```
- Apply the configuration:
  ```sh
  terraform apply
  ```

### 2. **Build and Push Docker Image**
- Run the push_docker_image.sh script:
  ```sh
  ./push_docker_image.sh
  ```

### 3. **Deploy via GitHub Actions**
- Push changes to the `main` branch to trigger the CI/CD pipeline defined in deploy-to-ecs.yml.

---

## Application Access

Once deployed, the Flask application will be accessible via the DNS name of the ALB. The application returns the message:
```
POC of Deploying simple python application on ECS Completed successfully. Also Infra of ECS is created using Terraform.
```

---

## Notes
- Ensure the EC2 instance has the correct IAM role attached with the required permissions.
- Update the terraform.tfvars and GitHub secrets with appropriate values for your environment.
- The ALB health check path is set to `/`.

---

This document consolidates all the necessary steps and configurations for deploying your application securely using IAM roles. Let me know if you need further assistance!