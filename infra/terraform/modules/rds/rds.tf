# resource "aws_db_subnet_group" "rds" {
#   name       = "${var.app_name}-${terraform.workspace}"
#   subnet_ids = var.private_subnet_ids

#   tags = {
#     Name = "${var.app_name}${terraform.workspace}"
#   }
# }

resource "aws_db_instance" "main" {
  db_name                   = var.app_name
  identifier                = "${terraform.workspace}-backend-db"
  instance_class            = var.instance_class
  allocated_storage         = 20

  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  username                  = var.rds_username
  password                  = var.db_master_user_password

  # db_subnet_group_name      = aws_db_subnet_group.rds.name

  backup_retention_period   = 7
  skip_final_snapshot       = terraform.workspace != "prod"
  final_snapshot_identifier = "${terraform.workspace}-final-snapshot"

  deletion_protection       = terraform.workspace == "prod"
  delete_automated_backups  = terraform.workspace != "prod"
  multi_az                  = terraform.workspace == "prod"

  tags = {
    Name = "${terraform.workspace}-backend-db"
  }
}

