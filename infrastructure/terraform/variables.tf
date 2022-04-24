variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "IDs of subnets"
}

variable "batch_compute_name" {
  description = "Batch compute name"
  type        = string
  default     = "batch-compute"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name for accessing instances"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}
