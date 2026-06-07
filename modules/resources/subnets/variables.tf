
variable "vpc_id" {
  description = "The id of the VPC that the subnet belongs to"
  type        = string
}

variable "subnets" {
  description = "A map of subnet configuration objects"
  type = map(object({
    name                    = optional(string)
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = optional(bool, false)
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
