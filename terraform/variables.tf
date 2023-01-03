variable "vnet_name" {
  description = "Name of the virtual network which VM connects to"
  type = string
}

variable "vnet_rg" {
  description = "Resource group name of the virtual network"
  type = string
}

variable "vm_rg" {
  description = "Resource group name of the VM"
  type = string
}

variable "vm_rg_location" {
  description = "Location of the VM"
  type    = string
  default = "northeurope"
}

variable "vm_list" {
  description = "List of the VM need to be created"
  type = map(
    object({
      vm_name              = string
      rg_name              = string
      subnet_name          = string
      enable_public_access = bool
    })
  )
  default = {
  }
}
