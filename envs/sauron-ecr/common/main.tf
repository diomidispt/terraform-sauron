module "this" {
  source           = "../../../modules/resources/ecr"
  ecr_name         = var.ecr_name
  lifecycle_policy = var.lifecycle_policy
  iam_repo_admins  = var.iam_repo_admins
}