resource "azurerm_kubernetes_cluster" "sandbox-cluster" {

  name                = "sandbox-cluster"
  location            = azurerm_resource_group.aks-sandbox.location
  resource_group_name = azurerm_resource_group.aks-sandbox.name
  dns_prefix          = "sandbox-cluster"
  kubernetes_version  = "1.17.9"

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.sandbox_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  windows_profile {
    admin_username = "mbsadmin"
    admin_password = var.admin_password
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "windows_pool" {

  kubernetes_cluster_id = azurerm_kubernetes_cluster.sandbox-cluster.id
  name = "pool2"
  node_count = 1
  vm_size = "Standard_D4_v3"
  os_type = "Windows"
  vnet_subnet_id = azurerm_subnet.sandbox_subnet.id

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
