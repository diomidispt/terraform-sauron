variable "name" {
  description = "(Required) A String to uniquely identify your VPC"
  type        = string
}

variable "cidr_block" {
  description = "(Required) The CIDR block for the VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "(Required) A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "(Required) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  type        = bool
  default     = true
}

variable "enable_internet_access" {
  description = "(Optional) A boolean flag to enable/disable Internet access by creating an Internet Gateway in the VPC. Defaults true."
  type        = bool
  default     = true
}
