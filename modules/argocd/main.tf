resource "local_file" "argocd_values" {
  content  = templatefile("${path.module}/argocd-values.yaml.tpl", {
    ENV_GITOPS = var.environment
  })
  filename = "${path.module}/generated-argocd-values.yaml"
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.1.1"
  depends_on = [ kubernetes_secret.gitops_repo_ssh ]
  values = [
    "${file(local_file.argocd_values.filename)}"
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