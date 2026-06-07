module "iam_github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "5.39.1"
}

module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "5.39.1"

  name     = var.name
  subjects = var.allowed_repos

  policies = {
    GHActionPolicy = module.iam_github_policy.arn
  }
}

module "iam_github_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.39.1"

  name        = var.name
  path        = "/"
  description = "Policy with needed IAM permissions needed for running ops through GH actions."

  policy = jsonencode(var.iam_policy)
}