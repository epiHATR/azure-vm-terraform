variable "vnet_name" {
  type = string
}

variable "vnet_rg" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_rg" {
  type = string
}

variable "enable_public_access" {
  type    = bool
  default = false
}

variable "subnet_name" {
  type = string
}