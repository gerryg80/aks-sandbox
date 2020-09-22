resource "azurerm_container_registry" "acr" {
  name                     = "akssandbox${random_string.random-name.result}"
  resource_group_name      = azurerm_resource_group.aks-sandbox.name
  location                 = var.location
  sku                      = "Standard"
  admin_enabled            = true
}
