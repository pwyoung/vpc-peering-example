dependency "vpc" {
  config_path = "../vpc"
}

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
#  path = "${dirname(find_in_parent_folders())}/_env_common/aws/network-load-balancer.hcl"
#}


# Include our module by dynamically create some terraform code here.
terraform {
  # Keep this as a reminder to move to git-based modules
  #source = "${local.base_source_url}?ref=v0.7.0"
  #
  # Local module (for rapid dev)
  source = "${dirname(find_in_parent_folders())}//_modules/aws/lb"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  # https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf
  vpc_id  = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnets

  # https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/variables.tf#L25
  enable_cross_zone_load_balancing = true

}
