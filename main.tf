provider "azurerm" {
  version = ">=2.24.0"
  features {}
}

provider "azuread" {
  version = ">=0.11.0"
}

resource "azurerm_resource_group" "aks-sandbox" {
  name     = "aks-sandbox"
  location = var.location
}

resource "random_string" "random-name" {
  length  = 8
  upper   = false
  lower   = false
  number  = true
  special = false
}

