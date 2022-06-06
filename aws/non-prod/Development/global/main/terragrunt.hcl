# GOAL
#   Use the "dependencies" block to force creation of
#   all the modules required to build the entire system.
dependencies {
  paths = [
    "../../us-east-1/pub/ec2",
    "../../us-east-1/prv/ec2",
    "../../global/vpc-peering/us-east-1_us-east-2",
    "../../us-east-1/pub/nlb",
    "../../us-east-1/pub/nlb_attach_public_ec2_instances",
  ]
}

# Include the top-level terragrunt.hcl file
# That will:
# - Manage the remote_state
# - Manage the default Provider(s)
# - Assign some inputs (e.g. account, region, environment)
include "root" {
  path = find_in_parent_folders()
}


# Include our module by dynamically create some terraform code here.
terraform {
  source = "${dirname(find_in_parent_folders())}//_modules/aws/main"
}
