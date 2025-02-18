locals {
  aws_region       = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  tags = {
      Name       = "tova-portfolio"
      Email      = "tova.klein@develeap.com"
      project    = "tova-portfolio"
      stage      = "dev"
      Expiration = "10/01/2025"
      Objective  = "tova-portfolio"
    }
  cluster_name = "tova-portfolio-eks-cluster-dev"
  environment  = "dev"
}