variable "count" { }
variable "chef_server_url" { }
variable "chef_user_name" {}
variable "chef_user_key" { }
variable "resource_group" { }
variable "subnet_id" { }
variable "storage_account_name" { }
variable "storage_account_endpoint" { }
variable "admin_username" { default = "testAdmin" }
variable "admin_password" { default = "Password1234?" }

resource "azurerm_network_interface" "network_interface" {
    name = "hedgeops-web-${count.index}nic"
    location = "South Central US"
    resource_group_name = "${var.resource_group}"

    ip_configuration {
        name = "hedgeops-web-${count.index}nic"
        subnet_id = "${var.subnet_id}"
        private_ip_address_allocation = "dynamic"
    }

    count = "${var.count}"
}

resource "azurerm_storage_container" "storage_container" {
    name = "hedgeops-web-vhds"
    resource_group_name = "${var.resource_group}"
    storage_account_name = "${var.storage_account_name}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "web_virtual_machine" {
    name = "${format("hps-web%03d", count.index + 1)}"
    location = "South Central US"
    resource_group_name = "${var.resource_group}"
    network_interface_ids = ["${element(azurerm_network_interface.network_interface.*.id, count.index)}"]
    vm_size = "Standard_A0"
    
    connection {
        type = "winrm"
        user = "${var.admin_username}"
        password = "${var.admin_password}"
    }

    provisioner "chef" {
      use_policyfile  = true
      policy_group = "development"
      policy_name = "hedgeops-webserver"
      server_url = "${var.chef_server_url}"
      node_name = "${format("hps-web%03d", count.index + 1)}"
      user_name = "${var.chef_user_name}"
      user_key = "${var.chef_user_key}"
    }

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "${format("hps-web-disk%03d", count.index + 1)}"
        vhd_uri = "${format("${var.storage_account_endpoint}${azurerm_storage_container.storage_container.name}/hps-web-disk%03d.vhd", count.index + 1)}"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${format("hps-web%03d", count.index + 1)}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_windows_config {
        provision_vm_agent = true
        enable_automatic_upgrades = false
    }

    tags {
        environment = "Production"
    }

    count = "${var.count}"
}