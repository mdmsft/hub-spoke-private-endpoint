data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    tenant_id            = var.tenant_id
    subscription_id      = var.backend_subscription_id
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "hs-pe-h"
    client_id            = var.client_id
    client_secret        = var.client_secret
    use_azuread_auth     = true
  }
}

data "azurerm_resource_group" "main" {
  name = data.terraform_remote_state.hub.outputs.spoke_resource_group_name
}
