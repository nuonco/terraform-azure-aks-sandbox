data "azurerm_subscription" "main" {}

resource "azurerm_role_definition" "runner" {
  name        = "${var.nuon_id}-runner"
  scope       = data.azurerm_subscription.main.id
  description = "Role used by runner to manage the account."

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.main.id,
  ]
}

resource "azurerm_user_assigned_identity" "runner" {
  name                = "${var.nuon_id}-runner"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = azurerm_role_definition.runner.name
  principal_id         = azurerm_user_assigned_identity.runner.principal_id
}
