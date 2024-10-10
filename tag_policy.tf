resource "azurerm_policy_definition" "inherit_tag" {
  name         = "Inherit a tag from the resource group"
  policy_type  = "BuiltIn"
  mode         = "Indexed"
  display_name = "Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task."

  metadata = jsonencode({
    version : "1.0.0",
    category : "Tags"
  })

  policy_rule = jsonencode({
    if : {
      anyOf : [
        for k, v in local.tags : {
          field : "[concat('tags[', ${k}, ']')]",
          notEquals : "[resourceGroup().tags[${v}]]"
        }
      ]
    },
    then : {
      effect : "modify",
      details : {
        roleDefinitionIds : [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        operations : [
          for k, v in local.tags : {
            operation : "addOrReplace",
            field : "[concat('tags[', ${k}, ']')]",
            value : "[resourceGroup().tags[${v}]]"
          }
        ]
      }
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "inherit_tag" {
  name                 = "Inherit Tag Policy"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.inherit_tag.id
}
