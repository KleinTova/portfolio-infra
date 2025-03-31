resource "helm_release" "argocd" {
  name = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.1.1"
  depends_on = [ kubernetes_secret.gitops_repo_ssh ]
  # values = [
  #   file("argocd-values.yaml")
  # ]
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

module "external_secrets_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "external-secrets-role"
  oidc_providers = {
    eks = {
      provider_arn               = var.eks_oidc_provider_arn  # EKS OIDC provider ARN
      namespace_service_accounts = ["external-secrets:external-secrets-sa"]#var.external_secrets_namespace_service_accounts
    }
  }
}
# Attach the Secrets Manager policy separately
resource "aws_iam_role_policy_attachment" "external_secrets_secretsmanager_policy" {
  role       = module.external_secrets_irsa_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"  # Use the appropriate Secrets Manager policy ARN
}

# resource "aws_iam_policy" "external_secrets_policy" {
#   name        = "external-secrets-policy"
#   description = "Policy for External Secrets Operator to access AWS Secrets Manager"
  
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ]
#         Resource = "arn:aws:secretsmanager:us-east-1:006262944085:tova_portfolio_mongodb_credentials-IhCnka:*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "external_secrets_role" {
#   name = "external-secrets-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = var.eks_oidc_provider_arn  # שימוש במשתנה שהתקבל
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "${var.eks_oidc_issuer_url}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa"
#           }
#         }
#       }
#     ]
#   })
# }


# resource "aws_iam_role_policy_attachment" "attach_policy" {
#   policy_arn = aws_iam_policy.external_secrets_policy.arn
#   role       = aws_iam_role.external_secrets_role.name
# }

resource "kubectl_manifest" "app-of-apps" {
  depends_on = [
    helm_release.argocd
  ]

  yaml_body = <<YAML
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
    path: apps/dev
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: defaul
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}