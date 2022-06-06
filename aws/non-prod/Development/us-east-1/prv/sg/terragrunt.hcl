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


include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_env_common/aws/ec2-security-group.hcl"

  # Expose "source" so that it can be used in the terraform{} block below
  expose = true
}


# Include our module by dynamically create some terraform code here.
terraform {
  #source = "${dirname(find_in_parent_folders())}//_modules/aws/ec2_security_group"
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.7.0"
  source = "${include.envcommon.locals.base_source_url}"
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

  # These are set in _env_common/aws/ec2-security-group.hcl
  #
  # name
  # egress_rules
  # ingress_with_cidr_blocks

  # Redefine this
  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = 1
      description = "ALL ICMP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = 6
      description = "SSH via TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = 6
      description = "HTTP via TCP"
      cidr_blocks = "0.0.0.0/0"
    } ,
    {
      from_port   = 443
      to_port     = 443
      protocol    = 6
      description = "HTTPS via TCP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]


}
