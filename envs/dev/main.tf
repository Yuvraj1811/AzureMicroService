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


