variable "ecr_name" {
  description = "Name of the ECR repository to create."
  type        = string
}

variable "iam_repo_admins" {
  description = "List of AWS principals (ARNs) to grant permissions on the ECR repository."
  type        = list(string)
  default     = []
}

variable "lifecycle_policy" {
  description = "Lifecycle policy object for the ECR repository."
  type = object(
    {
      rules = list(
        object(
          {
            rulePriority = number
            description  = string
            selection = object(
              {
                tagStatus   = string
                countType   = string
                countNumber = number
              }
            )
            action = object(
              {
                type = string
              }
            )
          }
        )
      )
    }
  )

  default = {
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  }
}
