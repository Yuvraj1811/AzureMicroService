output "nic_id" {
  value = azurerm_network_interface.this.id

}

output "nsg_id" {
  value = azurerm_network_interface_security_group_association.this.id

}
