variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block public access to the S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "The policy to apply to the S3 bucket"
  type = object(
    {
      Version = string,
      Statement = list(
        object(
          {
            Effect    = string,
            Action    = list(string),
            Principal = map(list(string)),
            Resource  = list(string)
          }
        )
      )
    }
  )

  default = {
    Version   = "2012-10-17",
    Statement = []
  }

}

variable "directories" {
  description = "List of directories to create in the S3 bucket"
  type        = list(string)
  default     = []
}