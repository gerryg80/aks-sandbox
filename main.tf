provider "azurerm" {
  version = "=2.24.0"
  features {}
}

provider "azuread" {
  version = ">=0.11.0"
}

resource "azurerm_resource_group" "aks-sandbox" {
  name     = "aks-sandbox"
  location = var.location
}
