variable "env_name" {
  description = "The name for this environment (e.g., MyApp)"
  type        = string
}

variable "env_type" {
  description = "The type of this environment (e.g., DEV, PROD)"
  type        = string
}

variable "vpc" {
  description = "VPC configuration — requires a /20 CIDR"
  type = object({
    cidr_block = string
  })
}

variable "tags" {
  description = "Tags applied to all resources in the stack"
  type        = map(any)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Extra tags for private subnets (e.g. EKS discovery tags)"
  type        = map(any)
  default     = {}
}
