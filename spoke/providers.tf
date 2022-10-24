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
    key              = "hs-pe-s"
  }
}

provider "azurerm" {
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

provider "azurerm" {
  features {}
  alias           = "hub"
  tenant_id       = var.tenant_id
  subscription_id = var.hub_subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

provider "azuread" {
  tenant_id = var.tenant_id
}
