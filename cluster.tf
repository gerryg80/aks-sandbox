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

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "windows_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.sandbox-cluster.id
  name = "windows_pool"
  node_count = 1
  vm_size = "Standard_D4_v3"
  os_type = "Windows"
  node_taints = [
    "kubernetes.io/os=windows:NoSchedule"
  ]
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.sandbox-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.sandbox-cluster.kube_config_raw
}
