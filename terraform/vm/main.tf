data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_resource_group" "vm_rg" {
  name = var.vm_rg
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_public_ip" "vm_pip" {
  count               = var.enable_public_access == true ? 1 : 0
  name                = "${var.vm_name}-pip"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.vm_rg.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_access == true ? azurerm_public_ip.vm_pip.0.id : null
  }

  depends_on = [
    azurerm_public_ip.vm_pip
  ]
}

resource "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  location            = data.azurerm_resource_group.vm_rg.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  vm_size = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_04-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = "ubuntu"
    admin_password = "Password@1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = [
    azurerm_network_interface.vm_nic,
    azurerm_public_ip.vm_pip
  ]
}
