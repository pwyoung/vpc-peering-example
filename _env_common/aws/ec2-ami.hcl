locals {
  #app_vars = read_terragrunt_config(find_in_parent_folders("app_metadata.hcl"))
  #app_id = local.app_vars.locals.app_id

  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # env = local.environment_vars.locals.environment

  #region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  #aws_region = local.region_vars.locals.aws_region

  # scope_vars = read_terragrunt_config(find_in_parent_folders("scope.hcl"))
  # scope = local.scope_vars.locals.scope

  #base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git"
  # Local path relative to the root
  base_source_module_path = "_modules/aws/ec2_ami"
}

# MODULE DEFAULT PARAMETERS
#   These are essentially defaults as they can be overridden in the module/caller's terragrunt.hcl
inputs = {
  ec2_image_name = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  virtualization_type = ["hvm"]
  owners = ["099720109477"] # Canonical
}
