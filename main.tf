module "core" {
  source             = ".//core"
  customer_name      = var.customer_name
  tags               = var.tags
  jumpbox_cidr_block = var.jumpbox_cidr_block
  prod_region        = var.prod_region
  dr_region          = var.dr_region
}
module "vms" {
  source         = ".//vms"
  customer_name  = var.customer_name
  tags           = var.tags
  vms_per_subnet = var.vms_per_subnet
  prod_region    = var.prod_region
  subnets        = module.core.prod_subnets
  vm_type        = var.vm_type
  instance_password = var.instance_password
}