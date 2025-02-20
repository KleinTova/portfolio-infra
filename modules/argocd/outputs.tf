output "eks_cluster_role_arn" {
  description = "The ARN of the EKS Cluster Role"
  value       = helm_release.argocd.name
}
