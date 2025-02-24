resource "helm_release" "argocd" {
  name = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.1.1"
  depends_on = [ kubernetes_secret.gitops_repo_ssh ]
  values = [
    file("argocd-values.yaml")
  ]
}

resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "gitops_repo_ssh" {
  metadata {
    name      = "gitops-repo-ssh"
    namespace = "argocd" 
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "sshPrivateKey" = file("${path.module}/${var.ssh_private_path}")
    "type"          = "git"
    "url"           = var.repository_url
    "name"          = "github"
    "project"       = "*"
  }
}

# resource "kubernetes_manifest" "app-of-apps" {
#   depends_on = [ helm_release.argocd ]
#   manifest = {
#     "apiVersion" = "argoproj.io/v1alpha1"
#     "kind" = "Application"
#     "metadata" = {
#       "name" = "app-of-apps"
#       "namespace" = "argocd"
#       "finalizers" = [
#         "resources-finalizer.argocd.argoproj.io"
#       ]
#     }
#     "spec" ={
#       "project" = "default"
#       "source" = {
#         "repoURL" = "https://github.com/KleinTova/portfolio-gitops-config.git"
#         "targetRevision" = "main"
#         "path" = "apps/${var.environment}"
#       }
#       "destination" = {
#         "server" = "https://kubernetes.default.svc"
#         "namespace" = "default"
#       }
#       "syncPolicy" = {
#         "automated" = {
#           "prune" = "true"
#           "selfHeal" = "true"
#         }
#       }
#     }
#   }
# }