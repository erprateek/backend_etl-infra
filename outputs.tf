output "s3_bucket_name" {
  value = aws_s3_bucket.etl_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.etl_table.name
}

output "service_account_role_arn" {
  value = aws_iam_role.service_account.arn
}

output "db_admin_role_arn" {
  value = aws_iam_role.db_admin.arn
}
