identifier="postgres"

tags={
   dbname : "test-db"
}

# SUBNET-GROUP-VARIABLES

create_db_subnet_group = true
db_subnet_group_name="test-subnet-group"
db_subnet_group_use_name_prefix= true
db_subnet_group_description="postgres database subnet group"
subnet_ids= ["10.0.101.0/24","10.0.102.0/24"]
db_subnet_group_tags={
    subnetgroupname : "test-subnet-group"
}

# PARAMETER-GROUP-VARIABLES

create_db_parameter_group= true
parameter_group_name= "test-parameter-group"
parameter_group_use_name_prefix= true
parameter_group_description= "postgres database parameter group"
family="postgres14"
parameters= [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]
db_parameter_group_tags={
    parametergroupname : "test-parameter-group"
}

#OPTION GROUP
 major_engine_version = "14"  
# DB-INSTANCE-VARIABLES

 create_db_instance= true
 engine= "postgres"
 engine_version=14
 instance_class    = "db.t3.micro"
 allocated_storage = 20
 max_allocated_storage = 25

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "completePostgresql"
  username = "complete_postgresql"
  port     = 5432

  # setting manage_master_user_password_rotation to false after it
  # has been set to true previously disables automatic rotation
  manage_master_user_password = false
  manage_master_user_password_rotation              = true
  #master_user_password_rotate_immediately           = false
  master_user_password_rotation_schedule_expression = "rate(15 days)"

  multi_az               = false
  vpc_security_group_ids = ["sg-046a2cec28266cf90"]
  publicly_accessible= false
  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "example-monitoring-role-name"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Description for monitoring role"
