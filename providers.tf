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