resource "azuread_user" "this" {
  for_each            = { for i, v in var.users : i => v }
  user_principal_name = "${each.value.name}@${var.domain_name}"
  display_name        = each.value.name
  mail_nickname       = each.value.name
  password            = var.user_default_password
  depends_on = [
    azuread_group.this
  ]
}

resource "azuread_group_member" "this" {
  for_each         = { for i, v in var.users : i => v }
  group_object_id  = azuread_group.this.id
  member_object_id = azuread_user.this[each.key].id
  depends_on = [
    azuread_user.this,
    azuread_group.this
  ]
}
