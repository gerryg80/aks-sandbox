resource "azurerm_virtual_network" "sandbox_vnet" {
  name = "sandboxVirtualNetwork"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  address_space       = ["10.0.0.0/8"]
#  dns_servers         = ["10.0.0.4","10.0.0.5"]
}

resource "azurerm_subnet" "sandbox_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.aks-sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

