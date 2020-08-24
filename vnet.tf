resource "azurerm_virtual_network" "sandbox_vnet" {
  name = "sandboxVirtualNetwork"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  address_space       = ["10.192.0.0/14"]
#  dns_servers         = ["10.192.0.4","10.192.0.5"]
}

resource "azurerm_network_security_group" "sandboxnsg" {
  name                = "sandboxNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
}

resource "azurerm_subnet" "sandbox_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.aks-sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.193.0.0/16"]
}

