variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the public subnets"
  type        = list(string)
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to access via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidr" {
  description = "CIDR blocks allowed to access via HTTP"
  type        = list(string)
}

variable "allowed_https_cidr" {
  description = "CIDR blocks allowed to access via HTTPS"
  type        = list(string)
}

