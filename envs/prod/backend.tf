terraform {
    backend "azurerm" {
    resource_group_name  = "Rg-tfstate"
    storage_account_name = "tfbackendstrg"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

provider "azurerm" {
  
  features {}
  subscription_id = "1ef3481e-bfe1-4160-aeeb-862132dc8f0e"
}