resource "azurerm_resource_group" "rg_prod" {
  name     = "${var.customer_name}-prod"
  location = var.prod_region
  tags = merge(
    var.tags
  )
}

resource "azurerm_resource_group" "rg_dr" {
  name     = "${var.customer_name}-dr"
  location = var.dr_region
  tags = merge(
    var.tags
  )
}

module "prod_vnet" {
  version             = "2.4.0"
  source              = "Azure/vnet/azurerm"
  vnet_name           = "${var.customer_name}-prod"
  resource_group_name = "${var.customer_name}-prod"
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet1 = ["Microsoft.Storage"],
    subnet2 = ["Microsoft.Storage"],
    subnet3 = ["Microsoft.Storage"]
  }

  depends_on = [azurerm_resource_group.rg_prod]

  tags = merge(
    var.tags
  )
}

module "dr_vnet" {
  version             = "2.4.0"
  source              = "Azure/vnet/azurerm"
  vnet_name           = "${var.customer_name}-dr"
  resource_group_name = "${var.customer_name}-dr"
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet1 = ["Microsoft.Storage"],
    subnet2 = ["Microsoft.Storage"],
    subnet3 = ["Microsoft.Storage"]
  }

  depends_on = [azurerm_resource_group.rg_dr]

  tags = merge(
    var.tags
  )
}

resource "azurerm_network_security_group" "prod_nsg" {
  name                = "${var.customer_name}-prod-sg"
  location            = azurerm_resource_group.rg_prod.location
  resource_group_name = azurerm_resource_group.rg_prod.name

  security_rule {
    name                       = "${var.customer_name}-mgmt-inbound"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.jumpbox_cidr_block
    destination_address_prefix = "*"
  }
  tags = merge(
    var.tags
  )
}

resource "azurerm_subnet_network_security_group_association" "subnet0-sg" {
  subnet_id                 = module.prod_vnet.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.prod_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet1-sg" {
  subnet_id                 = module.prod_vnet.vnet_subnets[1]
  network_security_group_id = azurerm_network_security_group.prod_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2-sg" {
  subnet_id                 = module.prod_vnet.vnet_subnets[2]
  network_security_group_id = azurerm_network_security_group.prod_nsg.id
}