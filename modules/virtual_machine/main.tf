resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.vm_name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  network_interface_ids           = [var.nic_id]
  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yml", {
    container_image = var.container_image
    container_name  = var.container_name
    container_port  = var.container_port
    monitor_script = templatefile("${path.module}/scripts/monitor.py", {
      container_name = var.container_name
    })
    })
  )

}

