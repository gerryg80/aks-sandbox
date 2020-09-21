resource "azurerm_storage_account" "pod-storage-account" {
  name                     = "pod-storage-account"
  resource_group_name      = azurerm_resource_group.aks-sandbox.name
  location                 = azurerm_resource_group.aks-sandbox.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "pod-storage" {
  name                 = "pod-storage"
  storage_account_name = azurerm_storage_account.pod-storage-account.name
  quota                = 5
}
