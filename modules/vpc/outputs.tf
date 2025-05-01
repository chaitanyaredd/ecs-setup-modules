# filepath: ./modules/vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  description = "The IDs of the public subnets"
}

output "security_group_id" {
  value       = [aws_security_group.web_sg.id]
  description = "The ID of the security group for web traffic"
}