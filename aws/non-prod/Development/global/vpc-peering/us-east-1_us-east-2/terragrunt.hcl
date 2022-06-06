dependency "vpc_requester" {
  config_path = "../../../us-east-1/vpc"
}

dependency "vpc_accepter" {
  config_path = "../../../us-east-2/vpc"
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
  source = "${dirname(find_in_parent_folders())}//_modules/aws/vpc-peering"
}


# MODULE PARAMETERS
#   These are the variables we have to pass in to use the module.
#   This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run.
#
# Extra/unused inputs are ignored since they're just passed as environment variables
inputs = {
  owner = "pwy"

  this_vpc_id = dependency.vpc_requester.outputs.vpc_id
  this_vpc_region = "us-east-1"

  peer_vpc_id  = dependency.vpc_accepter.outputs.vpc_id
  peer_vpc_region = "us-east-2"

}
