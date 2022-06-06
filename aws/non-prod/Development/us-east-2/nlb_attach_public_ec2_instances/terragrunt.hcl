dependency "nlb" {
  config_path = "../nlb"
}

dependency "public_ec2_instances" {
  config_path = "../public_ec2_instances"
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
  source = "${dirname(find_in_parent_folders())}//_modules/aws/lb_attach_ec2_instances"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  # This is relying on the order of the target_group_arns being the same as input
  # TODO: Change this to a robust mechanism
  target_group_arn = dependency.nlb.outputs.target_group_arns[0]

  ec2_instance_ids = dependency.public_ec2_instances.outputs.ids

  ports = [22,80]

}
