output "prod_vnet_id" {
  description = "prod vnet id"
  value       = module.prod_vnet.vnet_id
}
output "prod_vnet_name" {
  description = "prod vnet name"
  value       = module.prod_vnet.vnet_name
}
output "dr_vnet_id" {
  description = "dr vnet id"
  value       = module.dr_vnet.vnet_id
}
output "dr_vnet_name" {
  description = "dr vnet name"
  value       = module.dr_vnet.vnet_name
}
output "prod_subnets" {
  description = "subnets created in prod vnet"
  value       = module.prod_vnet.vnet_subnets
}
output "dr_subnets" {
  description = "subnets created in dr vnet"
  value       = module.dr_vnet.vnet_subnets
}
