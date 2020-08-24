resource "azurerm_virtual_network" "sandbox_vnet" {
  name = "sandboxVirtualNetwork"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  address_space       = ["10.192.0.0/14"]
#  dns_servers         = ["10.192.0.4","10.192.0.5"]
}

resource "azurerm_subnet" "sandbox_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.aks-sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.193.0.0/16"]
}

resource "azurerm_public_ip" "sandbox_pip" {
  name                = "sandboxPip"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "sandbox_firewall" {
  name                = "sandboxFirewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.sandbox_subnet.id
    public_ip_address_id = azurerm_public_ip.sandbox_pip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "sandbox_rules" {
  name                = "sandboxRuleCollection"
  azure_firewall_name = azurerm_firewall.sandbox_firewall.name
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "udpout"
    source_addresses      = ["10.193.0.0/16"]
    destination_ports     = ["1194", "123", "53"]
    destination_addresses = ["0.0.0.0/0"]
    protocols             = ["UDP"]
  }

  rule {
    name                  = "tcpout"
    source_addresses      = ["10.193.0.0/16"]
    destination_ports     = ["80", "443", "9000"]
    destination_addresses = ["0.0.0.0/0"]
    protocols             = ["TCP"]
  }
}
