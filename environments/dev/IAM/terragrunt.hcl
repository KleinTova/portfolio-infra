locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../modules/IAM"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = merge(
  local.global,
  local.common,
)