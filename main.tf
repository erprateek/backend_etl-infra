provider "aws" {
  region = var.aws_region
}

# Random suffix for unique S3 bucket name
resource "random_pet" "bucket_name" {}

resource "aws_s3_bucket" "etl_bucket" {
  bucket = "${var.s3_bucket_prefix}-${random_pet.bucket_name.id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "etl_bucket_block" {
  bucket = aws_s3_bucket.etl_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "etl_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.primary_key

  attribute {
    name = var.primary_key
    type = "S"
  }
}

# IAM Role for service account
resource "aws_iam_role" "service_account" {
  name = "service_account"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com" # or change based on where API is running
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "service_account_policy" {
  name = "service_account_policy"
  role = aws_iam_role.service_account.id
  policy = templatefile("iam-policies/service_account_policy.json", {
    bucket_name = aws_s3_bucket.etl_bucket.bucket,
    table_name  = aws_dynamodb_table.etl_table.name,
    region      = var.aws_region
  })
}

# IAM Role for db_admin
resource "aws_iam_role" "db_admin" {
  name = "db_admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "db_admin_policy" {
  name = "db_admin_policy"
  role = aws_iam_role.db_admin.id
  policy = templatefile("iam-policies/db_admin_policy.json", {
    table_name = aws_dynamodb_table.etl_table.name,
    region     = var.aws_region
  })
}
