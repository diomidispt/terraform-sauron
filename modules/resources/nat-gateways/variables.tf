variable "nat_gateways" {
  description = "(Required) A map of rat gateway configuration objects"
  type = map(object({
    name              = optional(string)
    connectivity_type = optional(string)
    subnet_id         = string
    elastic_ip        = optional(string)
  }))
}

