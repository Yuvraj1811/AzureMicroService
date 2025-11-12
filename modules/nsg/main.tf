resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name



  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = var.security_rule.name
      priority                   = var.security_rule.priority
      direction                  = var.security_rule.direction
      access                     = var.security_rule.access
      protocol                   = var.security_rule.protocol
      source_port_range          = var.security_rule.source_port_range
      destination_port_range     = var.security_rule.destination_address_prefix
      source_address_prefix      = var.security_rule.source_address_prefix
      destination_address_prefix = var.security_rule.destination_address_prefix
    }
  }


}



resource "azurerm_subnet_network_security_group_association" "this" {
 for_each = var.subnet_id
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.this.id
}
