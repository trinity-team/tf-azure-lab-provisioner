resource "azurerm_network_interface" "windows_nics" {
  count               = var.vms_per_subnet * length(var.subnets) #launch enough windows nics to to have var.instances_per_subnet instances in each of var.subnet[x]
  name                = format("%s${var.num_suffix_format}", "${var.customer_name}-win-nic", count.index + 1)
  location            = var.prod_region
  resource_group_name = "${var.customer_name}-prod"

  ip_configuration {
    name                          = format("%s${var.num_suffix_format}", "${var.customer_name}-win-cfg", count.index + 1)
    subnet_id                     = var.subnets[count.index % length(var.subnets)]
    private_ip_address_allocation = "Dynamic"
  }
  tags = merge(
    var.tags
  )
}
resource "azurerm_network_interface" "linux_nics" {
  count               = var.vms_per_subnet * length(var.subnets) #launch enough linux nics to to have var.instances_per_subnet instances in each of var.subnet[x]
  name                = format("%s${var.num_suffix_format}", "${var.customer_name}-lin-nic", count.index + 1)
  location            = var.prod_region
  resource_group_name = "${var.customer_name}-prod"

  ip_configuration {
    name                          = format("%s${var.num_suffix_format}", "${var.customer_name}-lin-cfg", count.index + 1)
    subnet_id                     = var.subnets[count.index % length(var.subnets)]
    private_ip_address_allocation = "Dynamic"
  }
  tags = merge(
    var.tags
  )
}
resource "azurerm_virtual_machine" "windows_vms" {
  for_each              = { for nic in azurerm_network_interface.windows_nics : nic.name => nic }
  name                  = replace(each.value.name, "nic", "vm")
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = [each.value.id]
  vm_size               = var.vm_type

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "2019.0.20190410"
  }
  storage_os_disk {
    name              = "${replace(each.value.name, "nic", "vm")}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = replace(each.value.name, "nic", "vm")
    admin_username = "rkadmin"
    admin_password = "Rubrik123$"
  }
  os_profile_windows_config {
  }
  tags = merge(
    var.tags,
    {
      platform = "windows"
    }
  )
}
resource "azurerm_virtual_machine" "linux_vms" {
  for_each              = { for nic in azurerm_network_interface.linux_nics : nic.name => nic }
  name                  = replace(each.value.name, "nic", "vm")
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = [each.value.id]
  vm_size               = var.vm_type

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${replace(each.value.name, "nic", "vm")}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = replace(each.value.name, "nic", "vm")
    admin_username = "rkadmin"
    admin_password = "Rubrik123$"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = merge(
    var.tags,
    {
      platform = "linux"
    }
  )
}