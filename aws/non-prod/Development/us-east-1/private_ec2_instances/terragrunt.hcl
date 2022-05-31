dependency "vpc" {
  config_path = "../vpc"
}

dependency "private_ec2_instance_profile" {
  config_path = "../../global/iam/private_ec2_instance_profile"
}


# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
# - Assign some inputs (e.g. account, region, environment)
include "root" {
  path = find_in_parent_folders()
}


# Set some common parameters (inputs) for this module
#include "aws_vpc" {
#  path = "${dirname(find_in_parent_folders())}/_env_common/aws/vpc.hcl"
#}


# Include our module by dynamically create some terraform code here.
terraform {
  # Keep this as a reminder to move to git-based modules
  #source = "${local.base_source_url}?ref=v0.7.0"
  #
  # Local module (for rapid dev)
  source = "${dirname(find_in_parent_folders())}//_modules/aws/ec2_instances"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  number_of_ec2_instances = 1
  ec2_key_name            = "tardis"
  #ec2_instance_type       = "t3.small"
  #ec2_image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  ec2_instance_name_prefix = "prv-ec2"

  iam_instance_profile = dependency.private_ec2_instance_profile.outputs.ec2_instance_profile

  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.private_subnets
  azs     = dependency.vpc.outputs.azs
}
