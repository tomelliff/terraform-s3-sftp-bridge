variable "integration_name" {}

variable "aws_account_id" {}

variable "lambda_s3_key" {
  default = "s3-sftp-bridge.zip"
}

variable "lambda_s3_bucket" {
  default = "dombi-lambda-deploy"
}

module "s3-sftp-bridge" {
  source           = "github.com/tomelliff/terraform-s3-sftp-bridge//s3-sftp-bridge"
  integration_name = "${var.integration_name}"
  aws_account_id   = "${var.aws_account_id}"
  config_file      = "config_file"
  lambda_s3_key    = "${var.lambda_s3_key}"
  lambda_s3_bucket = "${var.lambda_s3_bucket}"
}

output "kms_key_id" {
  value = "${module.s3-sftp-bridge.kms_key_id}"
}
