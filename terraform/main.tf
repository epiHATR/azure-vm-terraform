terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vm_rg" {
  name     = var.vm_rg
  location = var.vm_rg_location
}

module "azure_vm" {
  for_each = var.vm_list

  source = "./vm"

  vm_name              = each.value.vm_name
  vm_rg                = azurerm_resource_group.vm_rg.name
  vnet_name            = var.vnet_name
  vnet_rg              = var.vnet_rg
  subnet_name          = each.value.subnet_name
  enable_public_access = each.value.enable_public_access

  depends_on = [
    azurerm_resource_group.vm_rg
  ]
}
