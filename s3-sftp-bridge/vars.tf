variable "aws_account_id" {}

variable "integration_name" {}

variable "s3_versioning" {
  default = "false"
}

variable "lambda_s3_key" {
  default = "lambda_functions/s3-sftp-bridge.zip"
}

variable "lambda_s3_bucket" {
  default = "com.gilt.public.backoffice"
}
