provider "azurerm" {
  version = ">=2.24.0"
  features {}
}

provider "kubernetes" {
  host                   = module.kubernetes.host
  client_certificate     = base64decode(module.kubernetes.client_certificate)
  client_key             = base64decode(module.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)
}

resource "random_string" "random-name" {
  length  = 8
  upper   = false
  lower   = false
  number  = true
  special = false
}

module "subscription" {
  source = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = var.subscription_id
}

module "rules" {
  source = "git@github.com:openrba/python-azure-naming.git?ref=tf"
}

module "metadata"{
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = module.rules.yaml
  
  market              = var.market
  project             = var.project
  location            = var.location
  sre_team            = var.sre_team
  environment         = var.environment
  product_name        = var.product_name
  business_unit       = var.business_unit
  product_group       = var.product_group
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = var.subscription_type
  resource_group_type = var.resource_group_type
}

module "resource_group" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

module "virtual_network" {
  source = "github.com/Azure-Terraform/terraform-azurerm-virtual-network.git?ref=v2.2.0"

  naming_rules = module.rules.yaml

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["10.0.0.0/8"]

  subnets = {
    "iaas-public" = { cidrs             = ["10.240.0.0/16"]
                      deny_all_ingress  = false
                      deny_all_egress   = false }
  }
}

module "kubernetes" {
  source = "github.com/Azure-Terraform/terraform-azurerm-kubernetes.git?ref=v1.5.0"

  kubernetes_version = "1.18.8"
  
  location                 = module.metadata.location
  names                    = module.metadata.names
  tags                     = module.metadata.tags
  resource_group_name      = module.resource_group.name

  default_node_pool_name                = "default"
  default_node_pool_vm_size             = "Standard_D2as_v4"
  default_node_pool_enable_auto_scaling = true
  default_node_pool_node_min_count      = 1
  default_node_pool_node_max_count      = 5
  default_node_pool_availability_zones  = [1,2,3]

  aks_managed_vnet = false

  default_node_pool_subnet = {
    id                  = module.virtual_network.subnet["iaas-public"].id
    resource_group_name = module.virtual_network.vnet.resource_group_name
    security_group_name = module.virtual_network.subnet_nsg_names["iaas-public"]
  }

  network_plugin = "azure"
  enable_windows_node_pools = true

  windows_profile_admin_username = "mbsadmin"
  windows_profile_admin_password = var.admin_password

  use_service_principal = true

  service_principal_id = var.service_principal_id
  service_principal_secret = var.service_principal_secret
}

resource "azurerm_container_registry" "acr" {
  name                     = "akssandbox${random_string.random-name.result}"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.kubernetes.principal_id
}

resource "azurerm_kubernetes_cluster_node_pool" "windows_pool" {
  kubernetes_cluster_id = module.kubernetes.id
  name                  = "pool2"
  node_count            = 1
  vm_size               = "Standard_D4_v3"
  os_type               = "Windows"
  vnet_subnet_id        = module.virtual_network.subnet["iaas-public"].id

  tags = module.metadata.tags
}

resource "azurerm_storage_account" "pod_storage_account" {
  name                     = "podstorage${random_string.random-name.result}"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "pod_storage" {
  name                 = "pod-storage"
  storage_account_name = azurerm_storage_account.pod_storage_account.name
  quota                = 5
}

resource "kubernetes_secret" "pod_storage" {
  metadata {
    name = "pod-storage"
  }

  data = {
    azurestorageaccountname = azurerm_storage_account.pod_storage_account.name
    azurestorageaccountkey  = azurerm_storage_account.pod_storage_account.primary_access_key
  }
}

output "aks_login" {
  value = "az aks get-credentials --name ${module.kubernetes.name} --resource-group ${module.resource_group.name}"
}
