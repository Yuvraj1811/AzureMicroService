data "azurerm_key_vault" "kv" {
  name                = "AzureSecretCredentials "       
  resource_group_name = "Rg-tfstate"               
}


data "azurerm_key_vault_secret" "admin_password" {
  name         = "vmpassword"                 
  key_vault_id = data.azurerm_key_vault.kv.id
}