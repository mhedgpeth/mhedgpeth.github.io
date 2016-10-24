provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Create a resource group
resource "azurerm_resource_group" "resource_group" {
    name     = "hedgeops-${var.environment}-rg"
    location = "South Central US"
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "hedgeops-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "web_subnet" {
    name = "web-subnet"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_storage_account" "storage_account" {
    name = "hedgeopswebst0"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    location = "South Central US"
    account_type = "Standard_LRS"

    tags {
        environment = "${var.environment}"
    }
}

resource "azurerm_network_security_group" "security_group" {
    name = "hedgeops-web-nsg"
    location = "South Central US"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    security_rule {
        name = "allow-winrm"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Production"
    }
}

module "webservers" {
    source = "./webserver"
    count = 5
    chef_server_url = "${var.chef_server_url}"
    chef_user_name = "${var.chef_user_name}"
    chef_user_key = "${var.chef_user_key}"
    resource_group = "${azurerm_resource_group.resource_group.name}"
    subnet_id = "${azurerm_subnet.web_subnet.id}"
    storage_account_name = "${azurerm_storage_account.storage_account.name}"
    storage_account_endpoint = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
}
