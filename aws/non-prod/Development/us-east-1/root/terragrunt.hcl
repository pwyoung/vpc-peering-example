# Example of this pattern:
#   https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/4a8569c33088e13938d412f65a27a16d4e2d524b/non-prod/us-east-1/stage/mysql/terragrunt.hcl

# Include the top-level terragrunt.hcl file
# This does thigs like:
# - manage the backend (backend.tf files, if we are using that, which we should)
# - manage the default AWS provider (so that the region is automatically applied)
# - create some global parameters
include "root" {
  path = find_in_parent_folders()
}


# Set some parameters (inputs) for this module
include "root_module" {
  path = "${dirname(find_in_parent_folders())}/_cfg_global/root-module.hcl"
}

# Include our module by dynamically create some terraform code here.
terraform {
  # Keep this as a reminder to move to git-based modules
  #source = "${local.base_source_url}?ref=v0.7.0"
  #
  # Local module (for rapid dev)
  source = "${dirname(find_in_parent_folders())}/_modules/root"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
inputs = {
  # "environment" is set dynamically via root-module.hcl (and exposed via the inputs{} block there)
  # "app_id" is hard-coded in root-module.hcl (and exposed via the inputs{} block there)

  # Extra/unused inputs are ignored since they're just passed as environment variables
  owner = "pwy"
  public_ec2_key_name = "tardis"
  public_ec2_instance_type = "t3.medium"
}
