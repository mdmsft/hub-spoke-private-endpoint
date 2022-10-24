resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.resource_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "workloads" {
  name                 = "snet-vm"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
  address_prefixes     = [cidrsubnet(var.address_space, 1, 0)]
}

resource "azurerm_subnet" "endpoints" {
  name                                      = "snet-pe"
  virtual_network_name                      = azurerm_virtual_network.main.name
  resource_group_name                       = data.azurerm_resource_group.main.name
  address_prefixes                          = [cidrsubnet(var.address_space, 1, 1)]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_network_security_group" "workloads" {
  name                = "nsg-${local.resource_suffix}-vm"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_network_security_group" "endpoints" {
  name                = "nsg-${local.resource_suffix}-pe"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "workloads" {
  network_security_group_id = azurerm_network_security_group.workloads.id
  subnet_id                 = azurerm_subnet.workloads.id
}

resource "azurerm_subnet_network_security_group_association" "endpoints" {
  network_security_group_id = azurerm_network_security_group.endpoints.id
  subnet_id                 = azurerm_subnet.endpoints.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  for_each              = data.terraform_remote_state.hub.outputs.private_dns_zones
  name                  = azurerm_virtual_network.main.name
  private_dns_zone_name = each.key
  resource_group_name   = split("/", each.value).4
  virtual_network_id    = azurerm_virtual_network.main.id
  provider              = azurerm.hub
}

resource "azurerm_public_ip_prefix" "main" {
  name                = "ippre-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  prefix_length       = 31
  sku                 = "Standard"
}

resource "azurerm_virtual_network_peering" "hub" {
  name                         = reverse(split("/", data.terraform_remote_state.hub.outputs.virtual_network_id)).0
  resource_group_name          = data.azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = data.terraform_remote_state.hub.outputs.virtual_network_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke" {
  name                         = azurerm_virtual_network.main.name
  resource_group_name          = split("/", data.terraform_remote_state.hub.outputs.virtual_network_id).4
  virtual_network_name         = reverse(split("/", data.terraform_remote_state.hub.outputs.virtual_network_id)).0
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  provider                     = azurerm.hub
}
