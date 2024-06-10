terraform {
  required_version = "~>1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.74.0"
    }
    alz = {
      source  = "Azure/alz"
      version = "0.11.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth = true
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
