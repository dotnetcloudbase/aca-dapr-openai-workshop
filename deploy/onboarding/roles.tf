resource "azurerm_role_assignment" "this" {
  for_each             = { for i, v in var.users : i => v }
  scope                = azurerm_resource_group.this[each.key].id
  role_definition_name = "Owner"
  principal_id         = azuread_user.this[each.key].id
}
