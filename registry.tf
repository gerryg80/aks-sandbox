resource "random_string" "random-name" {
  length  = 8
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_container_registry" "acr" {
  name                     = "akssandbox${random_string.random-name.result}"
  resource_group_name      = azurerm_resource_group.aks-sandbox.name
  location                 = azurerm_resource_group.aks-sandbox.location
  sku                      = "Standard"
  admin_enabled            = false
}
