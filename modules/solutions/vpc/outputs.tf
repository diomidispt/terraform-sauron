output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  value = module.vpc.cidr
}

output "public_subnet_ids" {
  value = { for k, v in module.subnets_public.subnets : k => v.id }
}

output "private_subnet_ids" {
  value = { for k, v in module.subnets_private.subnets : k => v.id }
}

output "nat_gateway_ids" {
  value = { for k, v in module.nat_gateways.nat_gateways : k => v.id }
}
