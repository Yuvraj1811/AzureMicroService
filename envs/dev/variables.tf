variable "rg_name" {}
variable "location" {}
variable "vneet_name" {}
variable "owner" {}
variable "project" {}
variable "tags" {
  type = map(string)
  default = {}

}
variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))

}
variable "nsg_name" {}
variable "security_rules" {}
variable "nic_name" {}
variable "vm_size" {}
variable "admin_username" {}

