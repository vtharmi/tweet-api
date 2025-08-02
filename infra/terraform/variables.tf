variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {

}

variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
  default     = "t2.micro"
}


variable "app_name" {
  type        = string
  description = "Application name"
  default     = "tweet"
}

//db
variable "db_engine" {
  type        = string
  default     = "postgres"
  description = "The database engine to use for the RDS instance"
}

variable "db_engine_version" {
  type        = string
  default     = "14"
  description = "The version of the database engine to use for the RDS instance"
}

variable "db_master_user_password" {}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of private subnet IDs for the RDS instance"
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of public subnet IDs for the RDS instance"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "CIDR block range for the public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR block range for the private subnets"
}

# variable "ssh_public_key" {
#   type        = string
#   description = "Public key for deploying to ec2"
# }