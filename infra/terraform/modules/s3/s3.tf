resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-s3-bucket-${terraform.workspace}"

  tags = {
    Name = "${var.app_name}-s3-bucket-${terraform.workspace}"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
