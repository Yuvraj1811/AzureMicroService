resource "azurerm_virtual_network" "this" {
  name                = var.vneet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers


  tags = merge({
    environment = var.environment
    created_by  = "Terraform"
    },
    var.tags
  )
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
}
