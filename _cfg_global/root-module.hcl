# This is intended to be included in a child "terragrunt.hcl" via a block such as the following:
#   include "root" {
#     path = "${dirname(find_in_parent_folders())}/<SOME_PATH>/<THIS_FILE>"
#   }

# TG Locals
#   These are convenient aliases visible only within this file, per
#     https://terragrunt.gruntwork.io/docs/features/locals/#locals
locals {
  # Use this with: "terraform{ source = "${local.base_source_url}" }
  # Keep this as a reminder to move to git-based modules
  # base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql"
}

# Example: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/terragrunt.hcl#L54-L66
#
# This defines the parameters that are common across all environments.
#   TG transforms these to "TF_VAR_<input_name>=<input_value>" in the TF run,
#   in order to set the corresponding variable(s) required by the module.
#
#inputs = merge(
#  local.account_vars.locals,
#  local.region_vars.locals,
#  local.environment_vars.locals,
#)