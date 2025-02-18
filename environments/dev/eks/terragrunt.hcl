locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../../modules/eks"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

dependency "network" {
  config_path = "../network" 
}

dependency "IAM" {
  config_path = "../IAM" 
}

inputs = merge(
  local.global,
  local.common,
  {
    vpc_id               = dependency.network.outputs.vpc_id
    public_subnets       = dependency.network.outputs.public_subnets
    private_subnets      = dependency.network.outputs.private_subnets
    eks_cluster_role_arn = dependency.IAM.outputs.eks_cluster_role_arn
    eks_node_role_arn    = dependency.IAM.outputs.eks_node_role_arn
    eks_sg_id            = dependency.network.outputs.eks_sg_id
    scaling_desired_size = "3"
    scaling_max_size     = "4"
    scaling_min_size     = "2"
    cluster_addons       = [
        "coredns",
        "vpc-cni",
        "kube-proxy",
        "aws-ebs-csi-driver"
      ]
    instance_types       = "t3a.large"
    capacity_type        = "ON_DEMAND"
    ami_type             = "AL2_x86_64"
    disk_size            = "50"
  }
)