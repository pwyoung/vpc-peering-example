dependency "vpc" {
  config_path = "../../vpc"
}

dependency "private_ec2_instance_profile" {
  config_path = "../../../global/iam/private_ec2_instance_profile"
}

dependency "sg" {
  config_path = "../sg"
}

dependency "ami" {
  config_path = "../ami"
}


# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
# - Assign some inputs (e.g. account, region, environment)
include "root" {
  path = find_in_parent_folders()
}


include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_env_common/aws/ec2-instances.hcl"

  expose = true
}


# Include our module by dynamically create some terraform code here.
terraform {
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.7.0"
  #source = "${include.envcommon.locals.base_source_url}"

  source = "${dirname(find_in_parent_folders())}//_modules/aws/ec2_instances"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {

  # PRIVATE
  subnets = dependency.vpc.outputs.private_subnets
  iam_instance_profile = dependency.private_ec2_instance_profile.outputs.ec2_instance_profile

  number_of_ec2_instances = 1

  # Specify these in ./*.auto.tfvars
  ec2_key_name            = "CHANGEME"
  owner = "CHANGEME"

  vpc_id  = dependency.vpc.outputs.vpc_id
  azs     = dependency.vpc.outputs.azs
  ami     = dependency.ami.outputs.ami
  security_group_id = dependency.sg.outputs.security_group_id

# Defaults
#   ec2_instance_name_prefix
#   ec2_instance_type
#   ec2_user_data

}
