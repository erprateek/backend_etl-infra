variable "aws_region" {
  default = "us-west-2"
}

variable "dynamodb_table_name" {
  default = "etl_pipeline_data"
}

variable "primary_key" {
  default = "id"
}

variable "s3_bucket_prefix" {
  default = "etl-pipeline-data"
}
