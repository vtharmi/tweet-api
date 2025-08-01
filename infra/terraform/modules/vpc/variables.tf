variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable "number_of_private_subnets" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

variable "number_of_public_subnets" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/18", "10.0.64.0/18"]
  description = "CIDR block range for the private subnets"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.128.0/18", "10.0.192.0/18"]
  description = "CIDR block range for the public subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for the selected region"
}

variable "region" {
  type        = string
  description = "The AWS region where resources have been deployed"
}
