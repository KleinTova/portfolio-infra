#-----Global-----

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Name       = "tova-portfolio"
    Email      = "tova.klein@develeap.com"
    project    = "tova-portfolio"
    stage      = "dev"
    Expiration = "10/01/2025"
    Objective  = "tova-portfolio"
  }
}

#-----Networking-----

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

#-----EKS-----

variable "cluster_name" {
  description = "The eks cluster name"
  type = string
}

variable "scaling_desired_size" {
  type = number
  default = 3
}

variable "scaling_max_size" {
  type = number
  default = 4
}

variable "scaling_min_size" {
  type = number
  default = 2
}

variable "addons" {
  type = set(string)
  default = [
    "coredns",
    "vpc-cni",
    "kube-proxy",
    "aws-ebs-csi-driver"
  ]
}

variable "instance_types" {
  description = "The instance type for the managed node group"
}

variable "capacity_type" {
  description = "The capacity type for the managed node group"
}

variable "ami_type" {
  description = "The AMI type for the managed node group"
}

variable "disk_size" {
  description = "The instance types for the managed node group"
}

#-----ArgoCD-----

variable "argo_values_file_path" {
  type = string
}

variable "ssh_private_path" {
  type = string
}