# Outputs the ID of the main VPC
output "vpc_id" {
  description = "The ID of the main VPC"
  value       = aws_vpc.main.id
  sensitive   = false
}

output "vpc_arn" {
  description = "The Amazon Resource Name (ARN) of the main VPC"
  value       = aws_vpc.main.arn
  sensitive   = false
}

output "rds_security_group_id" {
  description = "The ID of the security group used by RDS instances"
  value       = aws_security_group.rds.id
  sensitive   = false
}

# Outputs the ID of the security group used for DB tunneling
output "db_tunnel_security_group_id" {
  description = "The ID of the security group used for DB tunneling"
  value       = aws_security_group.db_tunnel.id
  sensitive   = false
}

# Outputs the ID of the security group used for ALB
output "alb_security_group_id" {
  description = "The ID of the security group used for ALB"
  value       = aws_security_group.alb.id
  sensitive   = false
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets in the VPC"
  value       = aws_subnet.private_subnet[*].id
  sensitive   = false
}

# Outputs the IDs of the public subnets in the VPC
output "public_subnet_ids" {
  description = "The IDs of the public subnets in the VPC"
  value       = aws_subnet.public_subnet.*.id
  sensitive   = false
}