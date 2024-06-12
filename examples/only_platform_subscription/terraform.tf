terraform {
  required_version = "~>1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.74.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.7.0"
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

provider "azapi" {
}

provider "alz" {
  lib_urls    = ["../../${path.root}/lib"] # TODO add version similar to alz_lib_ref = "platform/alz@v2024.03.00"
  use_alz_lib = false
}
