output "nsg_id" {
  value = azurerm_network_security_group.this.id

}

output "nsg_subnet_associations" {
  value = azurerm_subnet_network_security_group_association.this.id
}
