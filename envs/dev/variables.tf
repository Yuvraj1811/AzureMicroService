variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "vneet_name" {
  type = string
}
variable "owner" {
  type = string
}
variable "project" {
  type = string
}


///----Subnets-----\\\
variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

///----Public IP-----\\\\
variable "public_ip_map" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))
}

///----- NSG -----\\
variable "nsgs" {
  type = map(object({
    nsg_name    = string
    subnet_name = string
  }))
}

///------ Security Rules------\\\
variable "security_rules" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

///---- NIC -----\\\
variable "nics" {
  type = map(object({
    nic_name    = string
    subnet_name = string
  }))

}

///---- VM -----\\\
variable "vms" {
  type = map(object({
    vm_name         = string
    vm_size         = string
  }))

}

variable "admin_username" {
  type = string
}
variable "sql_admin_user" {
  type = string
}



