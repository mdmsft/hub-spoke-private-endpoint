data "azurerm_client_config" "main" {}

data "azuread_client_config" "main" {}

data "azurerm_storage_account" "main" {
  name                = var.backend_storage_account_name
  resource_group_name = var.backend_resource_group_name
}

data "azurerm_storage_container" "main" {
  name                 = var.backend_container_name
  storage_account_name = var.backend_storage_account_name
}
