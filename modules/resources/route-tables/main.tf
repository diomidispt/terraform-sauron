resource "aws_route_table" "this" {
  for_each = var.route_tables
  vpc_id   = var.vpc_id
  tags = tomap({
    "Name"          = each.value.name != null ? each.value.name : each.key
    "network:scope" = each.value.network_scope
  })

}

resource "aws_route" "this" {
  count                       = length(local.routes)
  route_table_id              = local.routes[count.index].route_table_id
  destination_cidr_block      = local.routes[count.index].destination_cidr_block
  destination_ipv6_cidr_block = local.routes[count.index].destination_ipv6_cidr_block
  destination_prefix_list_id  = local.routes[count.index].destination_prefix_list_id
  carrier_gateway_id          = local.routes[count.index].carrier_gateway_id
  core_network_arn            = local.routes[count.index].core_network_arn
  egress_only_gateway_id      = local.routes[count.index].egress_only_gateway_id
  gateway_id                  = local.routes[count.index].gateway_id
  nat_gateway_id              = local.routes[count.index].nat_gateway_id
  local_gateway_id            = local.routes[count.index].local_gateway_id
  network_interface_id        = local.routes[count.index].network_interface_id
  transit_gateway_id          = local.routes[count.index].transit_gateway_id
  vpc_endpoint_id             = local.routes[count.index].vpc_endpoint_id
  vpc_peering_connection_id   = local.routes[count.index].vpc_peering_connection_id

}

resource "aws_route_table_association" "this" {
  count          = length(local.subnets)
  subnet_id      = local.subnets[count.index].subnet_id
  route_table_id = local.subnets[count.index].route_table_id
}

resource "aws_main_route_table_association" "this" {
  for_each = {
    for k, v in var.route_tables :
    k => v if v.is_main == true
  }
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.this[each.key].id
}