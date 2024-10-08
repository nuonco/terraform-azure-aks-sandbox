locals {
  // we create a network with two address spaces - one for node pool subnets and one for services, gateways etc.
  address_spaces = ["10.0.0.0/16", "10.2.0.0/16"]
  // node pool subnets
  subnet_cidrs = ["10.0.0.0/23"]
  subnet_names = ["a"]

  // app and services
  appgw_cidr     = "10.2.0.0/24"
  service_cidr   = "10.2.1.0/24"
  dns_service_ip = "10.2.1.10"
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "~> 5.3.0"

  resource_group_name = azurerm_resource_group.rg.name
  address_spaces      = local.address_spaces

  // we create three subnets - one for the nodes, one for ingresses and one for pods
  subnet_prefixes = local.subnet_cidrs
  subnet_names    = local.subnet_names

  subnet_service_endpoints = {
    (local.subnet_names[0]) : ["Microsoft.Storage", "Microsoft.Sql"],
  }
  subnet_enforce_private_link_endpoint_network_policies = {
    (local.subnet_names[0]) : true
  }

  use_for_each = true
  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.rg]
}
