resource "aws_s3_bucket" "sftp_keys" {
  bucket = "s3-sftp-bridge-sftp-keys-${var.integration_name}-${var.aws_account_id}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Id":"PutObjPolicy",
  "Statement":[
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-sftp-bridge-sftp-keys-${var.integration_name}-${var.aws_account_id}/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid":"DenyUnEncryptedObjectUploads",
      "Effect":"Deny",
      "Principal":"*",
      "Action":"s3:PutObject",
      "Resource":"arn:aws:s3:::s3-sftp-bridge-sftp-keys-${var.integration_name}-${var.aws_account_id}/*",
      "Condition":{
        "StringNotEquals":{
          "s3:x-amz-server-side-encryption-aws-kms-key-id":"${aws_kms_key.configuration_key.key_id}"
        }
      }
    }
  ]
}
EOF

  versioning {
    enabled = "${var.s3_keys_versioning}"
  }

  tags {
    Name = "s3-sftp-bridge-sftp-keys-${var.integration_name}-${var.aws_account_id}"
  }
}
