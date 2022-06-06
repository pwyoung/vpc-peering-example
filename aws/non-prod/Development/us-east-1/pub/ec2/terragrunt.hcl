dependency "vpc" {
  config_path = "../../vpc"
}

dependency "public_ec2_instance_profile" {
  config_path = "../../../global/iam/public_ec2_instance_profile"
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

  # PUBLIC
  subnets = dependency.vpc.outputs.public_subnets
  iam_instance_profile = dependency.public_ec2_instance_profile.outputs.ec2_instance_profile

  number_of_ec2_instances = 4
  ec2_key_name            = "tardis"
  ec2_instance_name_prefix = "pub-ec2"
  owner = "pwy"

  vpc_id  = dependency.vpc.outputs.vpc_id
  azs     = dependency.vpc.outputs.azs
  ami     = dependency.ami.outputs.ami
  security_group_id = dependency.sg.outputs.security_group_id

# Defaults
#   ec2_instance_type       = "t3.small"
#   ec2_user_data = <<-EOT
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y postgresql-client htop iperf3 tree awscli mysql-client nfs-common redis-tools nginx
# EOT


}
