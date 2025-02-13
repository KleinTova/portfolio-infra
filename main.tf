module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  aws_region           = var.aws_region
  tags                 = var.tags
  cluster_name         = var.cluster_name
}

module "iam" {
  source       = "./modules/IAM"
  cluster_name = var.cluster_name
  tags         = var.tags
}

module "eks" {
  depends_on           = [ module.network , module.iam ]
  source               = "./modules/eks"
  cluster_name         = var.cluster_name
  vpc_id               = module.network.vpc_id
  public_subnets       = module.network.public_subnets
  private_subnets      = module.network.private_subnets
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  scaling_desired_size = var.scaling_desired_size
  scaling_max_size     = var.scaling_max_size
  scaling_min_size     = var.scaling_min_size
  cluster_addons       = var.addons
  instance_types       = var.instance_types
  capacity_type        = var.capacity_type
  ami_type             = var.ami_type
  disk_size            = var.disk_size
  tags                 = var.tags
  eks_sg_id            = module.network.eks_sg_id
}

module "argocd" {
  source                = "./modules/argocd"
  depends_on            = [ module.network, module.eks ]
  values_file_path      = var.argo_values_file_path
  ssh_private_path      = var.ssh_private_path
}
