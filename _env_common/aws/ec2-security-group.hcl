locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_metadata.hcl"))
  app_id = local.app_vars.locals.app_id

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  scope_vars = read_terragrunt_config(find_in_parent_folders("scope.hcl"))
  scope = local.scope_vars.locals.scope

  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git"
}

# Pattern example
#   https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/_envcommon/mysql.hcl
#   https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/_envcommon/webserver-cluster.hcl
#
#
#
# MODULE DEFAULT PARAMETERS
#   These are essentially defaults as they can be overridden in the module/caller's terragrunt.hcl
inputs = {
  name = "${local.app_id}-${local.env}-${local.aws_region}-${local.scope}"

  egress_rules = ["all-all"]

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
