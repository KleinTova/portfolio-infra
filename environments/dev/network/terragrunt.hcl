locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../modules/network"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = merge(
  local.global,
  local.common,
  {
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]
    private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
  }
)