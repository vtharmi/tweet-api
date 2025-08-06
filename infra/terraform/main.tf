module "rds" {
  source                  = "./modules/rds"
  app_name                = var.app_name
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  db_master_user_password = var.db_master_user_password
}


module "ec2" {
  source             = "./modules/ec2"
  app_name           = var.app_name
  region             = var.aws_region
}

module "s3" {
  source   = "./modules/s3"
  app_name = var.app_name
}

module "ecr" {
  source   = "./modules/ecr"
  app_name = var.app_name
}

