resource "aws_iam_role" "lambda_role" {
  name = "s3-sftp-bridge-${var.integration_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  role = "${aws_iam_role.lambda_role.id}"
  name = "s3_access"

  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"     :   "1",
      "Effect"  :   "Allow",

      "Action"  : [ "s3:CopyObject",
                    "s3:GetObject",
                    "s3:ListObjects",
                    "s3:PutObject" ],
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
                    "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_logging" {
  role = "${aws_iam_role.lambda_role.id}"
  name = "logging"

  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"     :   "1",
      "Effect"  :   "Allow",

      "Action"  : [ "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents" ],
      "Resource":   "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_kms_key" "configuration_key" {
  description = "s3-sftp-bridge-${var.integration_name}"

  provisioner "local-exec" {
    command = "aws kms encrypt --key-id ${aws_kms_key.configuration_key.key_id} --output text --plaintext fileb://${var.config_file} --query CiphertextBlob > encrypted_config"
  }
}

output "kms_key_id" {
  value = "${aws_kms_key.configuration_key.key_id}"
}

resource "aws_lambda_function" "s3_sftp_bridge_lambda" {
  s3_bucket     = "${var.lambda_s3_bucket}"
  s3_key        = "${var.lambda_s3_key}"
  function_name = "s3-sftp-bridge-${var.integration_name}"
  description   = "Used to sync files between S3 and SFTP servers"
  runtime       = "nodejs4.3"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "exports.handle"

  lifecycle {
    ignore_changes = ["environment.variable"]
  }
}
