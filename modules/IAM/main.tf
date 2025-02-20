resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy_attachment" "eks_cluster_policy" {
  name       = "${var.cluster_name}-eks-cluster-policy"
  roles      = [aws_iam_role.eks_cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_policy_attachment" "eks_vpc_resource_controller" {
  name       = "${var.cluster_name}-eks-vpc-resource-controller"
  roles      = [aws_iam_role.eks_cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_policy_attachment" "cluster-service-policy" {
  name       = "${var.cluster_name}-eks-service-policy"
  roles       = [aws_iam_role.eks_cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "eks_ebs_csi_policy" {
  name        = "tova_eks_ebs_csi_policy"
  description = "EBS CSI Driver policy for EKS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:CreateSnapshot",
          "ec2:CreateVolume",  # Added action
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:CreateTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eks_ebs_csi_policy_attachment" {
  name       = "${var.cluster_name}-eks_ebs_csi_policy_attachment"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = aws_iam_policy.eks_ebs_csi_policy.arn
}

resource "aws_iam_policy_attachment" "eks_worker_node_policy" {
  name       = "${var.cluster_name}-eks-worker-node-policy"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "eks_cni_policy" {
  name       = "${var.cluster_name}-eks-cni-policy"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "cloudwatch_agent_policy" {
  name       = "${var.cluster_name}-cloudwatch-agent-policy"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy_attachment" "container-registry" {
  name       = "${var.cluster_name}-container-registry"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "nodes-eks-nodes-ebs-access" {
  name       = "${var.cluster_name}-nodes-eks-nodes-ebs-access"
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
