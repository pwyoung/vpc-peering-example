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

variable "ec2_instance_name_prefix" {
  type        = string
  description = "This is used to name some IAM resources"
}

# TF does not allow functions (i.e. jsonencode) in the default assignment
# So, use this to support default and overrides to policies.

variable "policy" {
  type        = string
  description = "Set this to override the default Policy"
  default     = ""
}

variable "assume_role_policy" {
  type        = string
  description = "Set this to override the default Assume Role Policy"
  default     = ""
}
