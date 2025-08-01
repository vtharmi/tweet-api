# Create NAT Gateway(s) for Public Subnets
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.number_of_public_subnets
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "${terraform.workspace}-nat-gw-${count.index}"
  }
}

# Allocate Elastic IPs for NAT Gateway(s)
resource "aws_eip" "nat_eip" {
  count  = var.number_of_public_subnets
  domain = "vpc"

  tags = {
    Name = "${terraform.workspace}-eip-${count.index}"
  }
}
