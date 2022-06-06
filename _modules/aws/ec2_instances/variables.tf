########################################
# These are set by the top-level terragrunt.hcl.
# Most of these are set indirectly in files found
# in the path between the root and the module.
########################################

# Set by env.hcl
variable "environment" {
  type = string
}

# Set by region.hcl
variable "aws_region" {
  type = string
}

# Set by top-level/root ./terragrunt.hcl
variable "app_id" {
  type = string
}

########################################
# These are set in the low-level module,
#   e.g. Development/us-east-1/main/terraform.hcl
########################################

variable "owner" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.small"
}

variable "ec2_instance_name_prefix" {
  type = string
}

variable "number_of_ec2_instances" {
  default = 0
}

variable "ec2_user_data" {
  default = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y postgresql-client htop iperf3 tree awscli mysql-client nfs-common redis-tools
EOT
}

# VPC Info
variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(any)
}

variable "azs" {
  type = list(any)
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM Instance Profile to be applied to the EC2 instances"
}

variable "security_group_id" {
  type = string
}

variable "ami" {
  type = string
}
