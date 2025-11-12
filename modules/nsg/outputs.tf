output "nsg_id" {
  value = azurerm_network_security_group.this.id

}

output "nsg_subnet_associations" {
  value = { for k, v in azurerm_subnet_network_security_group_association.this : k => v.id }
}
