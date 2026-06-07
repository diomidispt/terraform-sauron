output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "name" {
  description = "The name of the VPC"
  value       = aws_vpc.this.tags_all["Name"]
}

output "cidr" {
  description = " The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association."
  value       = aws_vpc.this.main_route_table_id
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.this.default_network_acl_id
}

output "default_security_group" {
  description = "The ID of the security group that has replaced the default security group"
  value       = aws_default_security_group.this
}

output "internet_gateway" {
  value = length(aws_internet_gateway.this) == 1 ? aws_internet_gateway.this[0] : null
}
