variable "allowed_repos" {
  description = "List of GitHub repositories allowed to assume the role. Format: repo_owner/repo_name:branch or repo_owner/repo_name:* for all branches"
  type        = list(string)
}

variable "name" {
  description = "The name of the IAM role and policy"
  type        = string
}

variable "iam_policy" {
  description = "The IAM policy document to attach to the role"
  type = object(
    {
      Version = string,
      Statement = list(
        object(
          {
            Effect   = string,
            Action   = list(string),
            Resource = string
          }
        )
      )
    }
  )
}