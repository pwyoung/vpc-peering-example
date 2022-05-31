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

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(any)
}

variable "private_subnets" {
  type = list(any)
}

variable "single_nat_gateway" {
  type = string
}

variable "enable_nat_gateway" {
  type = string
}

