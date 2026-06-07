module "this" {
  source        = "../../../modules/solutions/github-actions-ci-role"
  name          = var.name
  allowed_repos = var.allowed_repos
  iam_policy    = var.iam_policy
}