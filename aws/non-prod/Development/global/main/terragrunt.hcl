# GOAL
#   Use the "dependencies" block to force creation of
#   all the modules required to build the entire system.
dependencies {
  paths = [
    "../../us-east-1/pub/ec2",
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
