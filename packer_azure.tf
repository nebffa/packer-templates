variable "azure_subscription_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "location" {
  default = "southeastasia"
}

provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}

resource "azurerm_resource_group" "learning" {
  name = "learning"
  location = "${var.location}"
}

resource "azurerm_storage_account" "packer" {
  name                = "vibratopacker"
  resource_group_name = "${azurerm_resource_group.learning.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "packer" {
  name = "packer"
  storage_account_name = "${azurerm_storage_account.packer.name}"
  resource_group_name = "${azurerm_resource_group.learning.name}"
  container_access_type = "private"
}
