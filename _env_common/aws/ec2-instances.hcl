locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_metadata.hcl"))
  app_id = local.app_vars.locals.app_id

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  scope_vars = read_terragrunt_config(find_in_parent_folders("scope.hcl"))
  scope = local.scope_vars.locals.scope

  # Call local module
  #base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git"
}

# MODULE DEFAULT PARAMETERS
#   These are essentially defaults as they can be overridden in the module/caller's terragrunt.hcl
inputs = {

  prefix_name = "${local.app_id}-${local.env}-${local.aws_region}-${local.scope}"

  ec2_instance_type       = "t3.small"

  ec2_user_data = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y postgresql-client htop iperf3 tree awscli mysql-client nfs-common redis-tools nginx
EOT


}
