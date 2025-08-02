resource "aws_ecr_repository" "ecr_dkr" {
  name     = "${var.app_name}-${terraform.workspace}-ecr-registry"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.app_name}-${terraform.workspace}-backend"
  }
}

