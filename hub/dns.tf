resource "azurerm_private_dns_zone" "main" {
  for_each            = var.private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.main.name
}
