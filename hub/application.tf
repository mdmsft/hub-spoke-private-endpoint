locals {
  reader_scopes = [
    "/subscriptions/${var.subscription_id}",
    azurerm_resource_group.main.id
  ]
}

resource "azuread_application" "main" {
  display_name = "app-${local.resource_suffix}"
  owners       = [data.azuread_client_config.main.object_id]
}

resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id
  owners                       = [data.azuread_client_config.main.object_id]
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  end_date_relative    = "168h"
}

resource "azurerm_role_assignment" "reader" {
  count                            = length(local.reader_scopes)
  role_definition_name             = "Reader"
  principal_id                     = azuread_service_principal.main.object_id
  scope                            = local.reader_scopes[count.index]
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "contributor" {
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.main.object_id
  scope                            = azurerm_resource_group.spoke.id
  provider                         = azurerm.spoke
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "private_dns_zone_contributor" {
  for_each                         = azurerm_private_dns_zone.main
  role_definition_name             = "Private DNS Zone Contributor"
  principal_id                     = azuread_service_principal.main.object_id
  scope                            = each.value.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = azuread_service_principal.main.object_id
  scope                            = data.azurerm_storage_container.main.resource_manager_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "network_contributor" {
  role_definition_name             = "Network Contributor"
  principal_id                     = azuread_service_principal.main.object_id
  scope                            = azurerm_virtual_network.main.id
  skip_service_principal_aad_check = true
}
