resource "azurerm_resource_group" "this" {
  for_each = { for i, v in var.users : i => v }
  name     = each.value.resource_group_name
  location = each.value.resource_group_location
}
