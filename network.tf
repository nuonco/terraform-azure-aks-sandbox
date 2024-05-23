locals {
  // we create a network with two address spaces - one for node pool subnets and one for services, gateways etc.
  address_spaces = ["10.0.0.0/16", "10.2.0.0/16"]

  // node pool subnets
  subnet_cidrs = {
    (local.templates.fully_managed_single_subnet) : ["10.0.0.0/23"],
    (local.templates.fully_managed_multiple_subnets) : ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"],
  }

  subnet_names = {
    (local.templates.fully_managed_single_subnet) : ["a"],
    (local.templates.fully_managed_multiple_subnets) : ["a", "b", "c"],
  }

  subnet_service_endpoints = {
    (local.templates.fully_managed_single_subnet) : {
      (local.subnet_names[var.template][0]) : ["Microsoft.Storage", "Microsoft.Sql"],
    },
    (local.templates.fully_managed_multiple_subnets) : {
      (local.subnet_names[var.template][2]) : ["Microsoft.Storage", "Microsoft.Sql"],
    },
  }

  subnet_enforce_private_link_endpoint_network_policies = {
    (local.templates.fully_managed_single_subnet) : {
      (local.subnet_names[var.template][0]) : true
    },
    (local.templates.fully_managed_multiple_subnets) : {
      (local.subnet_names[var.template][2]) : true
    },
  }

  subnet_delegation = {
    (local.templates.fully_managed_single_subnet) : {
      a = [
        {
          name = "fs"
          service_delegation = {
            name = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      ]
    },
    (local.templates.fully_managed_multiple_subnets) : {
      c = [
        {
          name = "fs"
          service_delegation = {
            name = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      ]
    },
  }

  // app and services
  appgw_cidr     = "10.2.0.0/24"
  service_cidr   = "10.2.1.0/24"
  dns_service_ip = "10.2.1.10"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_spaces      = local.address_spaces

  // we create three subnets - one for the nodes, one for ingresses and one for pods
  subnet_prefixes = local.subnet_cidrs[var.template]
  subnet_names    = local.subnet_names[var.template]

  subnet_service_endpoints = local.subnet_service_endpoints[var.template]

  subnet_enforce_private_link_endpoint_network_policies = local.subnet_service_endpoints[var.template]

  subnet_delegation = local.subnet_delegation[var.template]

  use_for_each = true
  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.rg]
}
