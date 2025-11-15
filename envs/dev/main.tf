# RESOURCE GROUP
module "resource_group" {
  source   = "../../modules/resource_group"
  rg_name  = var.rg_name
  location = var.location

}

# VIRTUAL NETWORK
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

  depends_on = [module.resource_group]
}

# PUBLIC IP
module "public_ip" {
  source        = "../../modules/public_ip"
  rg_name       = var.rg_name
  location      = var.location
  public_ip_map = var.public_ip_map

  depends_on = [module.resource_group]

}

# NSG
module "national_security_group" {
  source         = "../../modules/nsg"
  for_each       = var.nsgs
  nsg_name       = each.value.nsg_name
  rg_name        = var.rg_name
  location       = var.location
  security_rules = var.security_rules
  subnet_id      = module.virtual_network.subnet_id[each.value.subnet_name]

  depends_on = [module.resource_group, module.virtual_network]

}

# NIC
module "network_interface_card" {
  source       = "../../modules/nic"
  for_each     = var.nics
  nic_name     = each.value.nic_name
  rg_name      = var.rg_name
  location     = var.location
  subnet_id    = module.virtual_network.subnet_id[each.value.subnet_name]
  nsg_id       = module.national_security_group[each.value.subnet_name].nsg_id
  public_ip_id = module.public_ip.public_ip_ids[each.value.subnet_name]

  depends_on = [module.resource_group, module.virtual_network, module.national_security_group, module.public_ip]
}

# KEY VAULT
data "azurerm_key_vault" "kv" {
  name                = "azuresecretcredentials"
  resource_group_name = "Rg-tfstate"
}


data "azurerm_key_vault_secret" "admin_password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sql_password" {
  name         = "sqlserverpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# VIRTUAL MACHINE
module "virtual_machine" {
  source         = "../../modules/virtual_machine"
  for_each       = var.vms
  vm_name        = each.value.vm_name
  rg_name        = var.rg_name
  location       = var.location
  nic_id         = module.network_interface_card[each.key].nic_id
  vm_size        = each.value.vm_size
  admin_username = var.admin_username
  admin_password = data.azurerm_key_vault_secret.admin_password.value

  depends_on = [module.network_interface_card, module.resource_group]


}

# SQL DATABASE
module "sql_database" {
  source             = "../../modules/database"
  sql_server_name    = "sqlserverdev09"
  databasename       = "sqldatabasedev09"
  rg_name            = var.rg_name
  location           = var.location
  sql_admin_user     = var.sql_admin_user
  sql_admin_password = data.azurerm_key_vault_secret.sql_password.value

  depends_on = [module.resource_group]

}

# PRIVATE ENDPOINT
module "private_endpoint" {
  source                         = "../../modules/private_endpoint"
  private_ep_name                = "pe-sql-demo"
  rg_name                        = var.rg_name
  location                       = var.location
  subnet_id                      = module.virtual_network.subnet_id["backend"]
  private_connection_resource_id = module.sql_database.sql_server_id

  depends_on = [module.virtual_network, module.sql_database]
}

# ACR
module "azure_container_registry" {
  source   = "../../modules/acr"
  acr_name = "acrinfra123"
  rg_name  = var.rg_name
  location = var.location

  depends_on = [module.resource_group]
}

