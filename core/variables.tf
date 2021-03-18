variable "customer_name" {
  type        = string
  description = "customer name string used to generate lab resource names"
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