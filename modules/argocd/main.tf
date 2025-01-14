resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.1.1"

}

resource "argocd_repository" "portfolio_repo" {
  repo_url = "https://github.com/KleinTova/portfolio-gitops-config.git"
}

resource "kubectl_manifest" "app_of_apps" {
  yaml_body = <<-EOF
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: app-of-apps
      namespace: argocd
      finalizers:
        - resources-finalizer.argocd.argoproj.io
    spec:
      project: default
      source:
        repoURL: 'https://github.com/KleinTova/portfolio-gitops-config.git'
        targetRevision: main
        path: apps
      destination:
        server: 'https://kubernetes.default.svc'
        namespace: default
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
  EOF

  depends_on = [helm_release.argocd]
}
