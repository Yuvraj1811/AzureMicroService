variable "vneet_name" {
  type = string

}

variable "rg_name" {
  type = string

}

variable "location" {
  type = string

}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}



variable "environment" {
  description = "Deployment Environment: dev, prod, qa"
  type        = string

}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}

}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))

}

