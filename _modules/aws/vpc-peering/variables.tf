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
# These are set in the module
########################################

variable "owner" {
  type = string
}

variable "requester_vpc_id" {
  type = string
}

variable "accepter_vpc_id" {
  type = string
}

#variable "account_id" {
#  type = string
#}

