variable "customer_name" {
  default     = "oasis"
  type        = string
  description = "customer name string used to generate lab resource names"
}
variable "vm_type" {
  default     = "Standard_DS1_v2"
  type        = string
  description = "type of vms to launch for this lab"
}
variable "vms_per_subnet" {
  default     = 2
  type        = number
  description = "Number of Windows and Linux instances to create in each subnet"
}
variable "prod_region" {
  default     = "East US 2"
  type        = string
  description = "region to build prod vnet in"
}
variable "dr_region" {
  default     = "West US 2"
  type        = string
  description = "region to build dr vnet in"
}
variable "tags" {
  type        = map
  description = "Default tags for infrastructure resources."
  default = {
    Owner = "oasis"
  }
}
variable "jumpbox_cidr_block" {
  type        = string
  description = "CIDR block allowed to connect to jumpbox"
}