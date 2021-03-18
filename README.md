# tf-azure-lab-provisioner

This module will produce the following resources for use in rubrik labs:
* 1 VNet with 3 subnets in the `prod_region`
* 1 VNet with 3 subnets in the `dr_region`
* 3*`vms_per_subnet` ubuntu vms, spread evenly across the 3 subnets in `prod_region`
* 3*`vms_per_subnet` windows vms, spread evenly across the 3 subnets in `prod_region`
* an ubuntu jumpbox with SSH and RDP whitelisted inbound from `jumpbox_cidr_blocks`
* a windows jumpbox with SSH and RDP whitelisted inbound from `jumpbox_cidr_blocks`

Resource names are prepended with `customer_name`, vms are of type `vm_type`. Only the jumpboxes are internet facing. Resource tags can be specified with `tags`.
