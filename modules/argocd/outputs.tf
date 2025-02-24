output "helm_release_name" {
  description = "The argocd helm release name"
  value       = helm_release.argocd.name
}
