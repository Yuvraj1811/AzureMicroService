resource "azurerm_private_endpoint" "this" {
  name                = var.private_ep_name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.private_ep_name}-connection"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
