output "orderbird_vpc_vpc_id" {
  value       = aws_vpc.orderbird_vpc.id
}

output "region" {
  value = var.region
}

output "project_name"{
  value = var.project_name
}

output "internet_gateway"{
  value=aws_internet_gateway.orderbird_internetgatway
}

output "private_subnet_list_output" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnet[*].id
}


output "public_subnet_list_output" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public_subnet[*].id
}

/*output "orderbird_vpc_loadbalancer_sg_id_output" {
  description = " loadbalancer security group id's"
  value       = aws_default_security_group.orderbird_vpc_loadbalancer_sg.id
}*/

/*output "orderbird_vpc_container_sg_id_output" {
  description = " container security group id's"
  value       = aws_default_security_group.orderbird_vpc_container_sg.id
}*/


output "aws_region_datsource_output" {
  description = "AWS region"
  value       = data.aws_region.region_datasource.name
}