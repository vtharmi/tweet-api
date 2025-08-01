resource "aws_instance" "app_instance" {
  ami           = "ami-0b6acaa45fec15278" 
  instance_type = "t3.micro"


  tags = {
    Name = "${var.app_name}-${terraform.workspace}-backend"
  }
}