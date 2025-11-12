output "vnet_id" {
  value = azurerm_virtual_network.this.id

}

output "subnet_is" {

  value = { for name, subnet in azurem_subnet.this : name => subnet.id }
}
