terraform {
  required_version = ">= 1.9.8"
  
  backend "azurerm" {
    resource_group_name  = "Rg-tfstate"
    storage_account_name = "tfbackendstrg"
    container_name       = "tfstate2"
    key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

provider "azurerm" {

  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  client_id = var.client_id
  client_secret = var.client_secret
}
