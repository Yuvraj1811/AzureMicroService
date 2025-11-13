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
variable "security_rules" {}
variable "vm_size" {}
variable "admin_username" {}
variable "sql_admin_user" {}



