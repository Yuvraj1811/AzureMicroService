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
  department = "DevOps"
  environment = "dev"
  costcenter = "CC101"
}