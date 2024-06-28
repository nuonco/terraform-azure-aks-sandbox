output "appgw_cidr" {
  value = local.appgw_cidr
}

output "service_cidr" {
  value = local.service_cidr
}

output "dns_service_ip" {
  value = local.dns_service_ip
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "vnet_subnets" {
  value = module.network.vnet_subnets
}
