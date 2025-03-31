variable "values_file_path" {
  type = string
}

variable "ssh_private_path" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_ca" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}


variable "eks_oidc_issuer_url" {}

variable "eks_oidc_provider_arn" {}

variable "environment" {
  type        = string
  description = "The environment name"
}
