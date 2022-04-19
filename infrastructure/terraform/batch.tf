resource "aws_batch_compute_environment" "batch_compute" {
  compute_environment_name = var.batch_compute_name

  compute_resources {
    instance_role      = aws_iam_instance_profile.ecs_instance_role.arn
    instance_type      = ["c3.large"] # 2 CPU	  3.75 GiB RAM	  2 x 16 GB SSD
    max_vcpus          = 2
    min_vcpus          = 0
    security_group_ids = [aws_security_group.batch_compute_sg.id]
    subnets            = var.subnet_ids
    type               = "EC2"
    ec2_key_pair       = "key_aws"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  state        = "ENABLED"

  depends_on = [
    aws_iam_instance_profile.ecs_instance_role,
    aws_security_group.batch_compute_sg,
    aws_iam_role_policy_attachment.aws_batch_service_role,
  ]
}

output "batch_compute" {
  value = aws_batch_compute_environment.batch_compute
}

resource "aws_batch_job_definition" "batch_compute_job_definition" {
  name                 = "${var.batch_compute_name}_job_definition"
  type                 = "container"
  container_properties = <<EOF
{
  "command": ["ls", "-lth", "/tmp"],
  "image": "busybox",
  "memory": 1024,
  "vcpus": 1,
  "volumes": [
    {
      "host": {
        "sourcePath": "/tmp"
      },
      "name": "tmp"
    }
  ],
  "environment": [
    {"name": "VARIABLE_NAME", "value": "VARIABLE_VALUE"}
  ],
  "mountPoints": [
    {
      "sourceVolume": "tmp",
      "containerPath": "/tmp",
      "readOnly": false
    }
  ],
  "ulimits": [
    {
      "hardLimit": 1024,
      "name": "nofile",
      "softLimit": 1024
    }
  ]
}
EOF

  depends_on = [aws_batch_compute_environment.batch_compute]
}

output "batch_compute_job_definition" {
  value = aws_batch_job_definition.batch_compute_job_definition
}

resource "aws_batch_job_queue" "batch_compute_job_queue" {
  name     = "${var.batch_compute_name}_job_queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.batch_compute.arn,
  ]
}

output "batch_compute_job_queue" {
  value = aws_batch_job_queue.batch_compute_job_queue
}
