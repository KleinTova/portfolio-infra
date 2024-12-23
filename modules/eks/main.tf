resource "aws_eks_cluster" "eks_cluster" {
  name          = var.cluster_name
  role_arn      = var.eks_cluster_role_arn
  vpc_config {
    subnet_ids = [
      var.private_subnets[0],
      var.private_subnets[1]
      ]
    endpoint_private_access = true
    endpoint_public_access = true
  }
  access_config {
    authentication_mode = "API"
  }

  tags = var.tags
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [
    var.private_subnets[0],
    var.private_subnets[1]
  ]
  instance_types = var.instance_types
  capacity_type  = var.capacity_type
  ami_type       = var.ami_type
  disk_size      = var.disk_size

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  tags = merge(
    var.tags,
    { 
      "kubernetes.io/role/internal-elb"                             = "1"
      "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned" }
  )
}

resource "aws_eks_addon" "addons" {
  for_each     = var.cluster_addons
  addon_name   = each.value
  cluster_name = aws_eks_cluster.eks_cluster.name
}

resource "aws_eks_access_entry" "eks-access" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = "arn:aws:iam::006262944085:user/tova_klein"
  type              = "STANDARD"
  
}
resource "aws_eks_access_policy_association" "console" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::006262944085:user/tova_klein"

  access_scope {
    type = "cluster"
  }
}

