locals {
  // app and services
  appgw_cidr     = "10.2.0.0/24"
  service_cidr   = "10.2.1.0/24"
  dns_service_ip = "10.2.1.10"
}

// Data source to reference existing Virtual Network created by Bicep
data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

// Data source to reference existing subnet
data "azurerm_subnet" "existing" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = var.vnet_resource_group_name
}
