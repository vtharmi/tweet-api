output "public_ip" {
  value = aws_instance.app_instance.public_ip
}

output "ec2_role" {
  value = aws_iam_role.ec2_role.name
}
