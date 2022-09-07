terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
  alias           = "hub"
  tenant_id       = var.tenant_id
  subscription_id = var.hub_subscription_id
}

provider "azurerm" {
  features {}
  alias           = "spoke"
  tenant_id       = var.tenant_id
  subscription_id = var.spoke_subscription_id
}

provider "azuread" {
  tenant_id = var.tenant_id
}
