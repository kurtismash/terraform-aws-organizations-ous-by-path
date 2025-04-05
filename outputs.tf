output "by_id" {
  description = "Map of all OUs indexed by id."
  value       = { for ou in local.all_ous : ou.id => ou }
}

output "by_name_path" {
  description = "Map of all OUs indexed by name_path."
  value       = { for ou in local.all_ous : ou.name_path => ou }
}

output "list" {
  description = "List of all OUs with added attributes id_path and name_path."
  value       = local.all_ous
}
