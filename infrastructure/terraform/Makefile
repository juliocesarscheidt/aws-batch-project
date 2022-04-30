#!make

# general variables
ENV?=development
PLAN_FILE?=tfplan
# AWS variables
AWS_ACCESS_KEY_ID?=
AWS_SECRET_ACCESS_KEY?=
AWS_DEFAULT_REGION?=us-east-1
# Terraform backend variables
AWS_BACKEND_BUCKET?=
AWS_BACKEND_ACCESS_KEY_ID?=
AWS_BACKEND_SECRET_ACCESS_KEY?=
AWS_BACKEND_REGION?=sa-east-1

create-backend-bucket:
	aws s3 ls s3://$(AWS_BACKEND_BUCKET) --region $(AWS_BACKEND_REGION) || \
		aws s3api create-bucket --bucket $(AWS_BACKEND_BUCKET) --region $(AWS_BACKEND_REGION) \
			--create-bucket-configuration LocationConstraint=$(AWS_BACKEND_REGION) --acl private

create-workspace:
	-@terraform_0.14.3 workspace new development 2> /dev/null
	-@terraform_0.14.3 workspace new staging 2> /dev/null
	-@terraform_0.14.3 workspace new production 2> /dev/null
	terraform_0.14.3 workspace select $(ENV)

init: create-backend-bucket
	terraform_0.14.3 init -upgrade=true \
		-backend-config="bucket=$(AWS_BACKEND_BUCKET)" \
		-backend-config="key=state.tfstate" \
		-backend-config="region=$(AWS_BACKEND_REGION)" \
		-backend-config="workspace_key_prefix=terraform/elasticbeanstalk-app-docker" \
		-backend-config="access_key=$(AWS_BACKEND_ACCESS_KEY_ID)" \
		-backend-config="secret_key=$(AWS_BACKEND_SECRET_ACCESS_KEY)" \
		-backend-config="encrypt=true"
	make create-workspace
	make plan

fmt:
	terraform_0.14.3 fmt -write=true -recursive

validate:
	terraform_0.14.3 validate

lint:
	docker container run --rm --name tflint --env TFLINT_LOG=debug -v $$(pwd):/data -t ghcr.io/terraform-linters/tflint

refresh:
	terraform_0.14.3 refresh	-var-file=$(ENV).tfvars

output:
	terraform_0.14.3 output -json

package:
	@echo "Package"

plan: validate lint
	-@echo "Plan"
	make package
	terraform_0.14.3 plan \
		-out=$(PLAN_FILE) \
		-var-file=$(ENV).tfvars \
		-var aws_region="$(AWS_DEFAULT_REGION)" \
		-input=false

apply:
	-@echo "Apply"
	terraform_0.14.3 apply $(PLAN_FILE)
	make output

destroy: plan
	-@echo "Destroy"
	terraform_0.14.3 destroy \
		-var-file=$(ENV).tfvars \
		-auto-approve
