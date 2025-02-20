locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../modules/app-of-apps"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

dependency "network" {
  config_path = "../network" 
}

dependency "eks" {
  config_path = "../eks" 
}

dependency "argocd" {
  config_path = "../argocd" 
}

inputs = merge(
  local.global,
  local.common,
  {
    eks_cluster_endpoint  = dependency.eks.outputs.eks_cluster_endpoint
    eks_cluster_ca        = dependency.eks.outputs.eks_cluster_certificate_authority
    eks_cluster_name      = dependency.eks.outputs.eks_cluster_name
  }
)