variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_ca" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}


variable "environment" {
  type        = string
  description = "The environment name"
}
