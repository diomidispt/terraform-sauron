variable "account" {
  type = object({
    id    = string
    alias = string
    name  = string
  })
}

variable "region" {
  type = object({
    id   = string
    name = string
  })
}

variable "environment_name" {
  description = "The name of the environment for the resources. The S3 bucket and DynamoDB table will have this name"
  type        = string
}