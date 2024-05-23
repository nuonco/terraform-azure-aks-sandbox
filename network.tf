module "network" {
  source              = "./network"
  template            = var.template
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg]
}
