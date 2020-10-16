variable "admin_password" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "service_principal_id" {
  type = string
}

variable "service_principal_secret" {
  type = string
}

variable "market" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "project" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "location" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "sre_team" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "environment" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "product_name" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "business_unit" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "product_group" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "subscription_type" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}

variable "resource_group_type" {
  description = "see here:  https://github.com/openrba/python-azure-naming"
  type        = string
}
