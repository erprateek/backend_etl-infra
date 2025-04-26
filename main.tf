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

# Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# Lambda Function
resource "aws_lambda_function" "etl_function" {
  function_name = "ETLFunction"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "path/to/your/lambda.zip"
}

# S3 Event Notification to Lambda
resource "aws_s3_bucket_notification" "s3_event" {
  bucket = aws_s3_bucket.etl_bucket.bucket

  lambda_function {
    events = ["s3:ObjectCreated:*", "s3:ObjectModified:*"]
    filter_prefix = "data/"
    lambda_function_arn = aws_lambda_function.etl_function.arn
  }
}

# Lambda Permissions for S3 Invocation
resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowS3Invocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.etl_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.etl_bucket.arn
}
