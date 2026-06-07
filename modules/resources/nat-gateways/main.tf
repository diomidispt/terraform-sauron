resource "aws_nat_gateway" "this" {
  for_each          = var.nat_gateways
  subnet_id         = each.value.subnet_id
  connectivity_type = each.value.connectivity_type
  allocation_id     = each.value.elastic_ip == null ? aws_eip.new[each.key].id : data.aws_eip.existing[each.key].id
  tags = tomap({
    "Name" = each.value.name != null ? each.value.name : each.key
  })

}

data "aws_eip" "existing" {
  for_each = {
    for key, val in var.nat_gateways :
    key => val if val.elastic_ip != null
  }
  public_ip = each.value.elastic_ip
}

resource "aws_eip" "new" {
  for_each = {
    for key, val in var.nat_gateways :
    key => val if val.elastic_ip == null
  }
  domain = "vpc"
  tags = {
    "Name" = "${each.value.name != null ? each.value.name : each.key}"
  }
}