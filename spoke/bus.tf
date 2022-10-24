resource "azurerm_servicebus_namespace" "main" {
  name                          = "sb-${local.resource_suffix}"
  location                      = data.azurerm_resource_group.main.location
  resource_group_name           = data.azurerm_resource_group.main.name
  sku                           = "Premium"
  capacity                      = 1
  local_auth_enabled            = false
  public_network_access_enabled = false
  zone_redundant                = true
}

resource "azurerm_private_endpoint" "bus" {
  name                = "pe-${local.resource_suffix}-sb"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.hub.outputs.private_dns_zones["privatelink.servicebus.windows.net"]]
  }

  private_service_connection {
    name                           = azurerm_servicebus_namespace.main.name
    is_manual_connection           = false
    subresource_names              = ["namespace"]
    private_connection_resource_id = azurerm_servicebus_namespace.main.id
  }
}
