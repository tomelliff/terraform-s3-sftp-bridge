get:
	terraform get -update=true

plan: get
	terraform plan -input=false

apply: get
	terraform apply -input=false

destroy: get
	terraform destroy -input=false -force

config:
	lambda_function_name2=s3-sftp-bridge-`grep integration_name terraform.tfvars | cut -d"=" -f2 | tr -d '[:space:]"'`; \
	key_id=`terraform output kms_key_id`; \
	encrypted_config=`aws kms encrypt --key-id $${key_id} --output text --plaintext fileb://config_file --query CiphertextBlob`; \
	aws lambda update-function-configuration --function-name $${lambda_function_name2} --environment Variables={CONFIG=$${encrypted_config}}

deploy: apply config
