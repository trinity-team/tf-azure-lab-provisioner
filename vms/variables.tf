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
variable "vms_per_subnet" {
  description = "Number of windows and linux vms to launch per subnet"
  type        = number
  default     = 1
}
variable "subnets" {
  description = "List of subnets to spread VMs across"
  type        = list(string)
}
variable "num_suffix_format" {
  description = "Numerical suffix format used as the disk and vm name suffix"
  type        = string
  default     = "-%d"
}
variable "prod_region" {
  type = string
}
variable "vm_type" {
  default     = "Standard_DS1_v2"
  type        = string
  description = "type of vms to launch for this lab"
}