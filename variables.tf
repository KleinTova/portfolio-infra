variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
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

variable "cluster_name" {
  description = "The eks cluster name"
  default = "tova-portfolio-eks-cluster"
  type = string
}

variable "scaling_desired_size" {
  type = number
  default = 2
}

variable "scaling_max_size" {
  type = number
  default = 3
}

variable "scaling_min_size" {
  type = number
  default = 1
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
  default = [
    "t3a.medium"
  ]
}

variable "capacity_type" {
  description = "The capacity type for the managed node group"
  default = "ON_DEMAND"
}

variable "ami_type" {
  description = "The AMI type for the managed node group"
  default = "AL2_x86_64"
}

variable "disk_size" {
  description = "The instance types for the managed node group"
  default = 50
}
