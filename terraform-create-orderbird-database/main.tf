
module "db_subnet_group" {
  source = "../MODULES/RDS/SUBNET-GROUP"
  create = var.create_db_subnet_group

  name            = coalesce(var.db_subnet_group_name, var.identifier)
  use_name_prefix = var.db_subnet_group_use_name_prefix
  description     = var.db_subnet_group_description
  subnet_ids      = var.subnet_ids

  tags = merge(var.tags, var.db_subnet_group_tags)
}

module "db_parameter_group" {
  source = "../MODULES/RDS/PARAMETER-GROUP"

  create = var.create_db_parameter_group
  name            = coalesce(var.parameter_group_name, var.identifier)
  use_name_prefix = var.parameter_group_use_name_prefix
  description     = var.parameter_group_description
  family          = var.family

  parameters = var.parameters

  tags = merge(var.tags, var.db_parameter_group_tags)
}

module "db_option_group" {
  source = "../MODULES/RDS/OPTION-GROUP"

  create = var.create_db_option_group

  name                     = coalesce(var.option_group_name, var.identifier)
  use_name_prefix          = var.option_group_use_name_prefix
  option_group_description = var.option_group_description
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version

  options = var.options

  timeouts = var.option_group_timeouts

  tags = merge(var.tags, var.db_option_group_tags)
}

module "db_instance_role_association" {
  source = "../MODULES/RDS/INSTANCE-ROLE-ASSOCIATION"
  for_each = { for k, v in var.db_instance_role_associations : k => v if var.create_db_instance }

  feature_name           = each.key
  role_arn               = each.value
  db_instance_identifier = module.db_instance.db_instance_identifier
}

module "db_instance" {
  source = "../MODULES/RDS/DB-INSTANCE"
  
  create                = var.create_db_instance
  identifier            = var.identifier
  use_identifier_prefix = var.instance_use_identifier_prefix

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  db_name                             = var.db_name
  username                            = var.username
  password                            = var.manage_master_user_password ? null : var.password
  port                                = var.port
  manage_master_user_password         = var.manage_master_user_password
  manage_master_user_password_rotation                   = var.manage_master_user_password_rotation
  master_user_password_rotation_automatically_after_days = var.master_user_password_rotation_automatically_after_days
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible
  maintenance_window          = var.maintenance_window
  skip_final_snapshot              = var.skip_final_snapshot
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  backup_retention_period              = var.backup_retention_period
  backup_window                        = var.backup_window
  max_allocated_storage                = var.max_allocated_storage
  monitoring_interval                  = var.monitoring_interval
  monitoring_role_arn                  = var.monitoring_role_arn
  monitoring_role_name                 = var.monitoring_role_name
  monitoring_role_use_name_prefix      = var.monitoring_role_use_name_prefix
  tags = merge(var.tags, var.db_instance_tags)
}

/*data "aws_caller_identity" "current" {}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for cross region automated backups replication"

  # Aliases
  aliases                 = "ORDERBIRD-KEY"
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]

  tags =  merge(var.tags, var.db_instance_tags)
}*/

