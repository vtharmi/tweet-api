# Internet gateway and attaches it to the main VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-igw"
  }
}
