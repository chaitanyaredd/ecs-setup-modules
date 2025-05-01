resource "aws_ecr_repository" "docker_repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = var.image_tag_mutability # or "MUTABLE"
  force_delete         = var.force_delete         # Automatically deletes images when deleting repo

  image_scanning_configuration {
    scan_on_push = var.scan_on_push               # Enable image scanning on push
  }

  tags = var.ecr_tags
}

