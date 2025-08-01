# Security group for ECS tasks
resource "aws_security_group" "ecs_tasks" {
  name   = "${terraform.workspace}-ecs-sg"
  vpc_id = aws_vpc.main.id

  # Allows inbound traffic on port 443 from the VPC CIDR block
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Allows outgoing traffic on TCP port 443 to AWS S3 via a VPC endpoint and the VPC CIDR block. 
  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    prefix_list_ids = [
      aws_vpc_endpoint.s3.prefix_list_id
    ]
  }

  # Allows outbound traffic on port 443 to the VPC CIDR block
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Allows all outbound traffic
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${terraform.workspace}-ecs-sg"
  }
}

# Security group for RDS instances
resource "aws_security_group" "rds" {
  name   = "${terraform.workspace}-rds-sg"
  vpc_id = aws_vpc.main.id

  # Allow incoming traffic from any IP address on port 5432 for PostgreSQL
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${terraform.workspace}-rds-sg"
  }
}

# Security group resource for SSH access to the database
resource "aws_security_group" "db_tunnel" {
  name   = "SSH"
  vpc_id = aws_vpc.main.id

  # Allow incoming traffic on port 22 for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic from the security group
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${terraform.workspace}-bastion-sg"
  }
}

# Load balancer allows ingress traffic on HTTP (80) and HTTPS (443) ports from all addresses (0.0.0.0/0). It also allows all outbound traffic.
resource "aws_security_group" "alb" {
  name   = "${terraform.workspace}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-lb-sg"
  }
}