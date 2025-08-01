# Private subnets in VPC
resource "aws_subnet" "private_subnet" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${terraform.workspace}-private-subnet-${count.index}"
  }
}

# Public subnets in VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = var.number_of_public_subnets
  map_public_ip_on_launch = true

  tags = {
    Name = "${terraform.workspace}-public-subnet-${count.index}"
  }
}

# Route table for public subnets in the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-routing-table-public"
  }
}

# Route table for private subnets in the VPC
resource "aws_route_table" "private" {
  count  = var.number_of_private_subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-routing-table-private"
  }
}

# Route for the route table that directs all traffic to the Internet Gateway
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Route for the route table that directs all traffic to the Internet Gateway
resource "aws_route" "private_nat_gateway" {
  count                  = var.number_of_private_subnets
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

# Associate the public subnets with the route table
resource "aws_route_table_association" "public" {
  count          = var.number_of_public_subnets
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Associate the public subnets with the route table
resource "aws_route_table_association" "private" {
  count          = var.number_of_private_subnets
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}