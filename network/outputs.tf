output "appgw_cidr" {
  value = local.network.appgw_cidr
}

output "service_cidr" {
  value = local.network.service_cidr
}

output "dns_service_ip" {
  value = local.network.dns_service_ip
}

output "vnet_name" {
  value = local.network.vnet_name
}

output "vnet_subnets" {
  value = local.network.vnet_subnets
}
