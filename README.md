# AWS Batch Jobs with ECS containers on EC2 basis

## Instructions

In order to deploy on AWS, go to the folder infrastructure/terraform/ and set the parameters on .tfvars files as follows:

```bash
cd infrastructure/terraform/

# development.tfvars
aws_region         = "us-east-1"
vpc_id             = "VPC-ID-0001"
subnet_ids         = ["SUBNET-ID-0001"]
batch_compute_name = "batch_compute_development"
```

And then use the Makefile for deploying, with the commands:

```bash
make init
make apply
```
