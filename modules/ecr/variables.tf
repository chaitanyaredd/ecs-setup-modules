variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability for the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "Whether to force delete the repository when deleted"
  type        = bool
  default     = true
}

variable "scan_on_push" {
  description = "Whether to scan images on push to the repository"
  type        = bool
  default     = true
}

variable "ecr_tags" {
  description = "Tags to apply to the ECR repository"
  type        = map(string)
}

