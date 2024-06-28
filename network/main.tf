locals {
  network = (
    length(module.fully_managed_multiple_subnets_network) == 1 ?
    module.fully_managed_multiple_subnets_network[0] :
    module.fully_managed_single_subnet_network[0]
  )
}

module "fully_managed_single_subnet_network" {
  count               = var.template == "fully_managed_single_subnet" ? 1 : 0
  source              = "./fully_managed_single_subnet"
  resource_group_name = var.resource_group_name
}

module "fully_managed_multiple_subnets_network" {
  count                 = var.template == "fully_managed_multiple_subnets" ? 1 : 0
  source                = "./fully_managed_multiple_subnets"
  resource_group_name   = var.resource_group_name
  a_subnet_delegations  = var.a_subnet_delegations
  b_subnet_delegations  = var.b_subnet_delegations
  db_subnet_delegations = var.db_subnet_delegations
}
