variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance class for the RDS instance"
}

variable "owners" {
  type        = list(string)
  default     = ["099720109477"]
  description = "A list of AWS account IDs that own the AMI"
}

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

variable "rds_username" {
  type        = string
  default     = "tweet-backend"
  description = "The username for the RDS instance"
}

variable "rds_security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs for the RDS instance"
}

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

variable "db_master_user_password" {
  type        = string
  description = "The password for the database master user"
}
