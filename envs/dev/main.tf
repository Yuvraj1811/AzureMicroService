module "resource_group" {
  source   = "../../modules/resource_group"
  rg_name  = var.rg_name
  location = var.location

}

module "virtual_network" {
  source      = "../../modules/network"
  vneet_name  = var.vneet_name
  rg_name     = var.rg_name
  location    = var.location
  environment = "dev"
  subnets     = var.subnets

  tags = {
    owner   = var.owner
    project = var.project
  }

}

module "network_security_group" {
  source         = "../../modules/nsg"
  nsg_name       = var.nsg_name
  rg_name        = var.rg_name
  location       = var.location
  security_rules = var.security_rules
  subnet_id      = module.virtual_network.subnet_id["frontend"]

}


module "network_interface_card" {
  source    = "../../modules/nic"
  nic_name  = var.nic_name
  rg_name   = var.rg_name
  location  = var.location
  subnet_id = module.virtual_network.subnet_id["frontend"]

}

data "azurerm_key_vault" "kv" {
  name                = "azuresecretcredentials"
  resource_group_name = "Rg-tfstate"
}


data "azurerm_key_vault_secret" "admin_password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}


module "virtual_machine" {
  source         = "../../modules/virtual_machine"
  vm_name        = "frontend_VM"
  rg_name        = var.rg_name
  location       = var.location
  nic_id         = module.network_interface_card.nic_id
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = data.azurerm_key_vault_secret.admin_password.value


}

