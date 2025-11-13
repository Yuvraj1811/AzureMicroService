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

module "frontend_nsg" {
  source         = "../../modules/nsg"
  nsg_name       = "frontendNSG"
  rg_name        = var.rg_name
  location       = var.location
  security_rules = var.security_rules
  subnet_id      = module.virtual_network.subnet_id["frontend"]

}

module "backend_nsg" {
  source         = "../../modules/nsg"
  nsg_name       = "backendNSG"
  rg_name        = var.rg_name
  location       = var.location
  security_rules = var.security_rules
  subnet_id      = module.virtual_network.subnet_id["backend"]

}


module "frontend_nic" {
  source    = "../../modules/nic"
  nic_name  = "frontendNIC"
  rg_name   = var.rg_name
  location  = var.location
  subnet_id = module.virtual_network.subnet_id["frontend"]
  nsg_id    = module.frontend_nsg.nsg_id


}

module "backend_nic" {
  source    = "../../modules/nic"
  nic_name  = "backendNIC"
  rg_name   = var.rg_name
  location  = var.location
  subnet_id = module.virtual_network.subnet_id["backend"]
  nsg_id    = module.backend_nsg.nsg_id

}

data "azurerm_key_vault" "kv" {
  name                = "azuresecretcredentials"
  resource_group_name = "Rg-tfstate"
}


data "azurerm_key_vault_secret" "admin_password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sql_password" {
  name         = "sqlpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}


module "frontend_virtual_machine" {
  source         = "../../modules/virtual_machine"
  vm_name        = "frontendVM"
  rg_name        = var.rg_name
  location       = var.location
  nic_id         = module.frontend_nic.nic_id
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = data.azurerm_key_vault_secret.admin_password.value

}

module "backend_virtual_machine" {
  source         = "../../modules/virtual_machine"
  vm_name        = "backendVM"
  rg_name        = var.rg_name
  location       = var.location
  nic_id         = module.backend_nic.nic_id
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = data.azurerm_key_vault_secret.admin_password.value

}


module "sql_database" {
  source             = "../../modules/database"
  sql_server_name    = "sqlserverdev09"
  databasename       = "sqldatabasedev09"
  rg_name            = var.rg_name
  location           = var.location
  sql_admin_user     = var.sql_admin_user
  sql_admin_password = data.azurerm_key_vault_secret.sql_password.value

}


module "private_endpoint" {
  source                         = "../../modules/private_endpoint"
  private_ep_name                = "pe-sql-demo"
  rg_name                        = var.rg_name
  location                       = var.location
  subnet_id                      = module.virtual_network.subnet_id["backend"]
  private_connection_resource_id = module.sql_database.sql_server_id
}

module "azure_container_registry" {
  source   = "../../modules/acr"
  acr_name = "acrinfra123"
  rg_name  = var.rg_name
  location = var.location


}

