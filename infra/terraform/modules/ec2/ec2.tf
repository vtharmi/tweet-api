resource "aws_instance" "app_instance" {
  ami                         = "ami-08a6efd148b1f7504"
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
  tags = {
    Name = "${var.app_name}-${terraform.workspace}-backend"
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-ecr-instance-profile"
  role = aws_iam_role.ec2_role.name
}

