resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-s3-bucket-${terraform.workspace}"

  tags = {
    Name = "${var.app_name}-s3-bucket-${terraform.workspace}"
  }
}

resource "aws_s3_bucket" "codebuild-cache" {
  bucket = "${var.app_name}-codebuild-cache-${terraform.workspace}-${random_string.random.result}"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket-artifacts-lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "clean-up"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}
