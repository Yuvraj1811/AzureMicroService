variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_ip_map" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))

}
