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
  subscription_id = "1ef3481e-bfe1-4160-aeeb-862132dc8f0e"
}
