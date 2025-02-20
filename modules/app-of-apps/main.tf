resource "kubernetes_manifest" "app-of-apps" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "app-of-apps"
      "namespace" = "argocd"
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    "spec" ={
      "project" = "default"
      "source" = {
        "repoURL" = "https://github.com/KleinTova/portfolio-gitops-config.git"
        "targetRevision" = "main"
        "path" = "apps/${var.environment}"
      }
      "destination" = {
        "server" = "https://kubernetes.default.svc"
        "namespace" = "default"
      }
      "syncPolicy" = {
        "automated" = {
          "prune" = "true"
          "selfHeal" = "true"
        }
      }
    }
  }
}