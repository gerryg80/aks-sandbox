resource "random_password" "aks-sandbox-sp-password" {
  length  = 32
  special = true
}

resource "azuread_application" "aks-sandbox" {
  name                       = "aks-sandbox"
  available_to_other_tenants = false
}

resource "azuread_service_principal" "aks-sandbox" {
  application_id = azuread_application.aks-sandbox.application_id
}

resource "azuread_service_principal_password" "aks-sandbox" {
  service_principal_id = azuread_service_principal.aks-sandbox.id
  value                = random_password.aks-sandbox-sp-password.result
  end_date_relative    = "17520h" # 2y
}
