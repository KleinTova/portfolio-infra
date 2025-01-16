terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }

  }
  backend "s3" {
    bucket = "tova-portfolio-terraform-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  shared_config_files      = ["/home/tova/.aws/config"]
  shared_credentials_files = ["/home/tova/.aws/credentials"]
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.eks_cluster_name]
    }
  }
}