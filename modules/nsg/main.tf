resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name



  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = var.security_rule.value.name
      priority                   = var.security_rule.value.priority
      direction                  = var.security_rule.value.direction
      access                     = var.security_rule.value.access
      protocol                   = var.security_rule.value.protocol
      source_port_range          = var.security_rule.value.source_port_range
      destination_port_range     = var.security_rule.value.destination_address_prefix
      source_address_prefix      = var.security_rule.value.source_address_prefix
      destination_address_prefix = var.security_rule.value.destination_address_prefix
    }
  }


}



resource "azurerm_subnet_network_security_group_association" "this" {

  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.this.id
}
