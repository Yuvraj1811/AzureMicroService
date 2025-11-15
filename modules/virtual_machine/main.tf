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
    commandToExecute = "bash docker_install.sh"
  })

  protected_settings = jsonencode({
    script = <<EOF
#!/bin/bash
set -e
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
EOF
  })
}



resource "azurerm_virtual_machine_extension" "docker_autostart" {
  name                 = "docker-autostart"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"


  depends_on = [
    azurerm_virtual_machine_extension.docker_install
  ]

  settings = jsonencode({
    commandToExecute = "bash docker_run.sh"
  })

  protected_settings = jsonencode({
    script = <<EOF
#!/bin/bash
docker pull ${var.acr_image}
docker stop app || true
docker rm app || true
docker run -d --name app -p ${var.container_port}:${var.container_port} ${var.acr_image}
EOF
  })
}




