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
    commandToExecute = "bash docker.sh"
  })

  protected_settings = jsonencode({
    script = <<EOF
#!/bin/bash

set -e

echo "Updating packages..."
sudo apt-get update -y

echo "Installing dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "Installing Docker..."
sudo apt-get install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ${var.admin_username}

echo "Docker installation completed"
docker --version
EOF
  })
}

resource "azurerm_virtual_machine_extension" "docker_autostart" {
  name                 = "docker-autostart"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "bash autostart.sh"
  })

  protected_settings = jsonencode({
    script = <<EOF
#!/bin/bash

SERVICE_FILE=/etc/systemd/system/${var.vm_name}.service

echo "Creating systemd service..."

sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Docker container service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p ${var.container_port}:${var.container_port} ${var.acr_image}
ExecStop=/usr/bin/docker stop $(docker ps -q --filter ancestor=${var.acr_image})

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable ${var.vm_name}.service
EOF
  })
}


