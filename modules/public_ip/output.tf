output "public_ip_ids" {
    value = {for k , v in azurerm_public_ip.this : k => v.id}
  
}

output "public_ip_address" {
    value = {for k, v in azazurerm_public_ip.this : k => v.ip_address}
  
}