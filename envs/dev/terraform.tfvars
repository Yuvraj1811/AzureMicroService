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
//----------NSG Name ----------\\
nsgs = {
  frontend = {
    nsg_name    = "frontend_nsg"
    subnet_name = "frontend"
  }
  backend = {
    nsg_name    = "backend_nsg"
    subnet_name = "backend"
  }

}

//----------Security Rules ----------\\
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

  },
  "allow_https" = {
    name                       = "Allow_HTTPS"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  "allow_dns_udp" = {
    name                       = "Allow_DNS_UDP"
    priority                   = 320
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  },

  allow_dns_tcp = {
    name                       = "Allow_DNS_TCP"
    priority                   = 330
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  }


}

///---- NIC ----\\\
nics = {
  frontend = {
    nic_name    = "frontend_nic"
    subnet_name = "frontend"
  }
  backend = {
    nic_name    = "backend_nic"
    subnet_name = "backend"
  }
}

/////---- Public IP ----\\\\\
public_ip_map = {
  frontend = {
    name              = "frontend_public_ip"
    allocation_method = "Static"
    sku               = "Standard"
  },
  backend = {
    name              = "backend_public_ip"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

/// ---- VM ---- \\\
vms = {
  frontend = {
    vm_name         = "frontendvm"
    vm_size         = "Standard_B1s"
    container_image = "acrinfra123.azurecr.io/react:v1"
    container_name  = "frontend"
    container_port  = 80


  },
  backend = {
    vm_name         = "backendvm"
    vm_size         = "Standard_B1s"
    container_image = "acrinfra123.azurecr.io/backend:v1"
    container_name  = "backend"
    container_port  = 8000

  }

}
admin_username = "azureuser"
sql_admin_user = "sqladminuser"
