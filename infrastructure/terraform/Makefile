#!make

PLAN_FILE?=tfplan
AWS_BACKEND_BUCKET?=
ENV?=development
AWS_DEFAULT_REGION?=us-east-1

init:
	-@echo "Init"
	terraform init -upgrade=true \
		-backend-config="bucket=$(AWS_BACKEND_BUCKET)" \
		-backend-config="key=state.tfstate" \
		-backend-config="region=$(AWS_DEFAULT_REGION)" \
		-backend-config="workspace_key_prefix=terraform/batch_compute" \
		-backend-config="access_key=$(AWS_ACCESS_KEY_ID)" \
		-backend-config="secret_key=$(AWS_SECRET_ACCESS_KEY)" \
		-backend-config="encrypt=true"

	-@terraform workspace new development 2> /dev/null
	-@terraform workspace new staging 2> /dev/null
	-@terraform workspace new production 2> /dev/null
	terraform workspace select $(ENV)

	make plan

fmt:
	terraform fmt -write=true -recursive

validate:
	terraform validate

plan: validate
	-@echo "Plan"
	terraform plan \
		-out=$(PLAN_FILE) \
		-var-file=$(ENV).tfvars \
		-var aws_region="$(AWS_DEFAULT_REGION)" \
		-var batch_compute_name="batch_compute_$(ENV)" \
		-input=false

apply: plan
	-@echo "Apply"
	terraform apply $(PLAN_FILE)
	terraform output -json

destroy: plan
	-@echo "Destroy"
	terraform destroy \
		-var-file=$(ENV).tfvars \
		-auto-approve
