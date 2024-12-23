variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster and nodes will be deployed"
  type        = string
}

variable "public_subnets" {
}

variable "private_subnets" {
}

variable "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  type        = string
}

variable "eks_node_role_arn" {
  description = "The ARN of the EKS node role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "scaling_desired_size" {
  type = number
}

variable "scaling_max_size" {
  type = number
}

variable "scaling_min_size" {
  type = number
}

variable "cluster_addons" {
  description = "Names of EKS add-ons to grant the cluster"
  type        = set(string)
}

variable "instance_types" {
}

variable "capacity_type" {
}

variable "ami_type" {
}

variable "disk_size" {
}