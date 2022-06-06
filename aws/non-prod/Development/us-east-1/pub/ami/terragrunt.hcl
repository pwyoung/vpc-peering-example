# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
include "root" {
  path = find_in_parent_folders()
}


include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_env_common/aws/ec2-ami.hcl"

  # Expose "base_source_module_path" so that it can be used in the terraform{} block below
  expose = true
}


# Include our module by dynamically create some terraform code here.
terraform {
  #source = "${dirname(find_in_parent_folders())}//_modules/aws/ec2_security_group"
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.7.0"
  #source = "${include.envcommon.locals.base_source_url}"

  # "${include.envcommon.locals.base_source_module_path}" = "_modules/aws/ec2_ami"

  source = "${dirname(find_in_parent_folders())}//_modules/aws/ec2_ami"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {

  # Defaults
  #ec2_image_name = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  #virtualization_type = ["hvm"]
  #owners = ["099720109477"] # Canonical
}
