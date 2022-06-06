dependency "vpc" {
  config_path = "../../vpc"
}

# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
include "root" {
  path = find_in_parent_folders()
}


# Include our module by dynamically create some terraform code here.
terraform {
  source = "${dirname(find_in_parent_folders())}//_modules/aws/nlb"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  vpc_id  = dependency.vpc.outputs.vpc_id

  # PUBLIC SUBNETS
  subnet_ids = dependency.vpc.outputs.public_subnets

  # https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/variables.tf#L25
  #enable_cross_zone_load_balancing = true # TODO: test this
}
