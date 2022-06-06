# Example of this pattern:
#   https://github.com/gruntwork-io/terragrunt-infrastructure-live-example

# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
# - Assign some inputs (e.g. account, region, environment)
include "root" {
  path = find_in_parent_folders()
}


# Set some parameters (inputs) for this module
#include "main_module" {
#  path = "${dirname(find_in_parent_folders())}/_env_common/aws/vpc.hcl"
#}


# Include our module by dynamically create some terraform code here.
terraform {
  # Keep this as a reminder to move to git-based modules
  #source = "${local.base_source_url}?ref=v0.7.0"
  #
  # Local module (for rapid dev)
  source = "${dirname(find_in_parent_folders())}//_modules/aws/vpc"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  # VPC
  vpc_cidr        = "10.1.0.0/16"
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

  # Private Network - NAT-GATEWAYS
  # For DEV (to save money during testing) skip private instances and NAT Gateway
  enable_nat_gateway = false  # false -> no NAT Gateway at all
  single_nat_gateway = true  # true -> one NAT in the first pub subnet (not in each subnet)

}
