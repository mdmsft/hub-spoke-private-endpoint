resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_suffix}"
  location = var.location.name

  tags = {
    role = "hub"
  }
}

resource "azurerm_resource_group" "spoke" {
  name     = "rg-${local.resource_suffix}"
  location = var.location.name
  provider = azurerm.spoke

  tags = {
    role = "spoke"
  }
}
