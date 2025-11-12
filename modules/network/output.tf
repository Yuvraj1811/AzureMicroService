output "vnet_id" {
  value = azurerm_virtual_network.this.id

}

output "subnet_id" {

  value = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}
