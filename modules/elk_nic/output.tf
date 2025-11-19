output "elk_nic_id" {
  description = "ID of the ELK NIC"
  value       = azurerm_network_interface.elk_nic.id
}

output "elk_public_ip" {
  description = "Public IP of the ELK NIC"
  value       = azurerm_public_ip.elk.ip_address
}

output "elk_nsg_id" {
  description = "ELK NSG ID"
  value       = azurerm_network_security_group.elk_nsg.id
}
