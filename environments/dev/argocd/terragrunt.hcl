locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../modules/argocd"
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

inputs = merge(
  local.global,
  local.common,
  {
    values_file_path      = "argocd-values.yaml"
    ssh_private_path      = "argocd_ssh"
    repository_url        = "git@github.com:KleinTova/portfolio-gitops-config.git"
    eks_cluster_endpoint  = dependency.eks.outputs.eks_cluster_endpoint
    eks_cluster_ca        = dependency.eks.outputs.eks_cluster_certificate_authority
    eks_cluster_name      = dependency.eks.outputs.eks_cluster_name
    eks_oidc_issuer_url   = dependency.eks.outputs.eks_oidc_issuer_url
    eks_oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn
  }
)