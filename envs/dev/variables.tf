variable "rg_name" {}
variable "location" {}
variable "vneet_name" {}
variable "owner" {}
variable "project" {}
variable "tags" {
  type    = map(string)
  default = {}

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

variable "admin_username" {}
variable "sql_admin_user" {}



