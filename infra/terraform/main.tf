module "vpc" {
  source                     = "./modules/vpc"
  app_name                   = var.app_name
  region                     = var.aws_region
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "rds" {
  source                  = "./modules/rds"
  app_name                = var.app_name
  private_subnet_ids      = module.vpc.private_subnet_ids
  instance_class          = var.instance_class
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  rds_username            = var.rds_username
  db_master_user_password = var.db_master_user_password
  rds_security_group_ids  = [module.vpc.rds_security_group_id]
}


module "ec2" {
  source   = "./modules/ec2"
  app_name = var.app_name
  vpc_id   = module.vpc.vpc_id
}

module "s3" {
  source   = "./modules/s3"
  app_name = var.app_name
}

module "codepipeline" {
  source               = "./modules/codepipeline"
  app_name             = var.app_name
  github_repo          = var.github_repo
  github_owner         = var.github_owner
  github_branch        = terraform.workspace
  github_oauth_token   = var.github_oauth_token
  artifact_bucket_name = module.s3.bucket_name
}
