output "nsg_ids" {
    value = {for k, nsg in module.national_security_group : k => nsg.nsg_id}
  
}

output "nic_ids" {
  value = { for k, v in module.network_interface_card : k => v.nic_id }
}

output "public_ip_ids" {
  value = module.public_ip.public_ip_ids
}

output "vm_ids" {
  value = { for k, v in module.virtual_machine : k => v.vm_id }
}


