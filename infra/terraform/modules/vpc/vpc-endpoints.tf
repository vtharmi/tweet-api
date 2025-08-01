# VPC Endpoint for ECR Docker Registry
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  # Allow traffic from the ECS Tasks security group
  security_group_ids = [
    "${aws_security_group.ecs_tasks.id}",
  ]

  tags = {
    Name = "${terraform.workspace}-ecr-registry-vpc-endpoint"
  }
}

# VPC Endpoint for ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  # Allow traffic from the ECS Tasks security group
  security_group_ids = [
    "${aws_security_group.ecs_tasks.id}",
  ]

  tags = {
    Name = "${terraform.workspace}-ecr-api-vpc-endpoint"
  }
}

# VPC endpoint for CloudWatch Logs service in the private subnets of the VPC
resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet.*.id
  private_dns_enabled = true

  security_group_ids = [
    "${aws_security_group.ecs_tasks.id}",
  ]

  tags = {
    Name = "${terraform.workspace}-cloudwatch-vpc-endpoint"
  }
}

# AWS VPC Endpoint for accessing S3 resources within the VPC
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_vpc.main.default_route_table_id]

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:Delete*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
  }
  EOF

  tags = {
    Name = "${terraform.workspace}-s3-vpc-endpoint"
  }
}

# AWS VPC endpoint for the SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [
    "${aws_security_group.ecs_tasks.id}",
  ]

  tags = {
    Name = "${terraform.workspace}-ssm-vpc-endpoint"
  }
}
