variable "aws_account_id" {}

variable "integration_name" {}

variable "config_file" {}

variable "s3_keys_versioning" {
  default = "true"
}

variable "s3_versioning" {
  default = "false"
}

variable "lambda_s3_key" {
  default = "lambda_functions/s3-sftp-bridge.zip"
}

variable "lambda_s3_bucket" {
  default = "com.gilt.public.backoffice"
}

variable "lambda_handler" {
  default = "main.handle"
}
