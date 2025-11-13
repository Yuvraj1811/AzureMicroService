rg_name    = "rginfra"
location   = "centralindia"
vneet_name = "vneetinfra"
owner      = "yuvraj"
project    = "Infra"
subnets = {
  frontend = {
    address_prefixes = ["10.0.1.0/24"]
  },
  backend = {
    address_prefixes = ["10.0.2.0/24"]
  }
}
tags = {
  department  = "DevOps"
  environment = "dev"
  costcenter  = "CC101"
}

security_rules = {
  "allow_ssh" = {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  "allow_http" = {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }

}

vm_size = "Standard_B1s"
admin_username = "azureuser"
sql_admin_user = "sqladminuser"
