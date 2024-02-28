#subnet group
output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_subnet_group.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_subnet_group.db_subnet_group_arn
}

#parameter group
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_parameter_group.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_parameter_group.db_parameter_group_arn
}
