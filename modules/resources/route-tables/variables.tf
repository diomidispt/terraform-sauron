
variable "vpc_id" {
  description = "(Required) The VPC ID"
  type        = string
}

variable "route_tables" {
  description = "(Required) A map of route table configuration objects"
  type = map(object({
    name          = optional(string)
    network_scope = string
    subnets       = list(string)
    is_main       = optional(bool)
    routes = list(object(
      {
        destination_cidr_block      = optional(string)
        destination_ipv6_cidr_block = optional(string)
        destination_prefix_list_id  = optional(string)
        nat_gateway_id              = optional(string)
        internet_gateway_id         = optional(string)
        carrier_gateway_id          = optional(string)
        core_network_arn            = optional(string)
        egress_only_gateway_id      = optional(string)
        gateway_id                  = optional(string)
        local_gateway_id            = optional(string)
        network_interface_id        = optional(string)
        transit_gateway_id          = optional(string)
        vpc_endpoint_id             = optional(string)
        vpc_peering_connection_id   = optional(string)
      }
    ))
  }))
  default = {}

}

# This is kept here in case we want to set defaults in the future
locals {

  subnets = flatten(
    [
      for route_table_key, route_table in var.route_tables : [
        for subnet_id in route_table.subnets : {
          route_table_id = aws_route_table.this[route_table_key].id
          subnet_id      = subnet_id
        }
      ]
    ]
  )

  routes = flatten([
    for route_table_key, route_table in var.route_tables : [
      for route_index, route in route_table.routes : {
        route_table_id              = aws_route_table.this[route_table_key].id
        destination_cidr_block      = route.destination_cidr_block
        destination_ipv6_cidr_block = route.destination_ipv6_cidr_block
        destination_prefix_list_id  = route.destination_prefix_list_id
        carrier_gateway_id          = route.carrier_gateway_id
        core_network_arn            = route.core_network_arn
        egress_only_gateway_id      = route.egress_only_gateway_id
        gateway_id                  = route.internet_gateway_id
        nat_gateway_id              = route.nat_gateway_id
        local_gateway_id            = route.local_gateway_id
        network_interface_id        = route.network_interface_id
        transit_gateway_id          = route.transit_gateway_id
        vpc_endpoint_id             = route.vpc_endpoint_id
        vpc_peering_connection_id   = route.vpc_peering_connection_id
      }
    ]
  ])
}