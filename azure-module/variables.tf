variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "storage_account_sku" {
  description = "The SKU of the storage account"
  type        = string
}
