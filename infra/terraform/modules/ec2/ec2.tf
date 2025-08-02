resource "aws_instance" "app_instance" {
  ami                         = "ami-08a6efd148b1f7504"
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids      = [var.security_group_ids]
  subnet_id                   = var.private_subnet_ids[0]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user

              # Login to ECR
              aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com

              # Pull Docker image from ECR
              docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/your-repo-name:latest

              # Run Docker container
              docker run -d -p 80:80 ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/your-repo-name:latest
              EOF
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-backend"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-ecr-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# resource "aws_key_pair" "ec2_key" {
#   key_name   = "${terraform.workspace}-ec2-backend-key"
#   public_key = var.ssh_public_key
# }
