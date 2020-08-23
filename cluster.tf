resource "azurerm_kubernetes_cluster" "sandbox-cluster" {

  name                = "sandbox-cluster"
  location            = azurerm_resource_group.aks-sandbox.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  dns_prefix          = "sandbox-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = azuread_service_principal.aks-sandbox.application_id
    client_secret = random_password.aks-sandbox-sp-password.result
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.sandbox-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.sandbox-cluster.kube_config_raw
}
