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

}

 resource "azurerm_virtual_machine_extension" "docker_install" {
  name                 = "install-docker"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = <<-EOF
      bash -c '
        set -e
        echo "--- Updating system ---"
        sudo apt-get update -y
        echo "--- Installing Docker ---"
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        sudo apt-get install -y docker.io
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker ${var.admin_username}
        docker --version
      '
    EOF
  })

}

