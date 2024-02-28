
# VPC2 FOLDER VARIABLES 

region = "eu-central-1"
vpc_cidr = "10.0.0.0/16"
project_name = "orderbird_dev"
environment ="dev"

public_subnet_List= ["10.0.1.0/24","10.0.2.0/24"]

private_subnet_List=["10.0.101.0/24","10.0.102.0/24"]

availabilityzonelist= ["eu-central-1a","eu-central-1b"]

instance_count=1
instance_type="t2.small"
tags={
    "server"="jenkinsserver"
}
