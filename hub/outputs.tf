output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "private_dns_zones" {
  value = { for k, v in azurerm_private_dns_zone.main : k => v.id }
}

output "spoke_resource_group_name" {
  value = azurerm_resource_group.spoke.name
}

output "service_principal_password" {
  value     = azuread_service_principal_password.main.value
  sensitive = true
}
