variable "integration_name" {}

variable "aws_account_id" {}

variable "config_file" {
  default = "config_file"
}

variable "lambda_s3_key" {
  default = "s3-sftp-bridge.zip"
}

variable "lambda_s3_bucket" {
  default = "dombi-lambda-deploy"
}

module "s3-sftp-bridge" "test" {
  source           = "github.com/tomelliff/terraform-s3-sftp-bridge//s3-sftp-bridge"
  integration_name = "${var.integration_name}"
  aws_account_id   = "${var.aws_account_id}"
  config_file      = "${var.config_file}"
  lambda_s3_key    = "${var.lambda_s3_key}"
  lambda_s3_bucket = "${var.lambda_s3_bucket}"
}
