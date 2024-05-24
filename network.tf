module "network" {
  source                = "./network"
  template              = var.template
  resource_group_name   = azurerm_resource_group.rg.name
  depends_on            = [azurerm_resource_group.rg]
  a_subnet_delegations  = var.a_subnet_delegations
  b_subnet_delegations  = var.b_subnet_delegations
  db_subnet_delegations = var.db_subnet_delegations
}
