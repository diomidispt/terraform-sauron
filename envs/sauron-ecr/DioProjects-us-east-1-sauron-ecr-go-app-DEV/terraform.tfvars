ecr_name = "go-app-dev"
iam_repo_admins = [
  "arn:aws:iam::298104300097:role/github-actions-ci",
]
lifecycle_policy = {
  rules = [
    {
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }
  ]
}
