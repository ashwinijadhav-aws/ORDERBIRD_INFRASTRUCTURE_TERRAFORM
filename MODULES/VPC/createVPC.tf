#VPC
resource "aws_vpc" "orderbird_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name ="vpc-${var.project_name}-${var.environment}"
  } 
}

# internet gateway
resource "aws_internet_gateway" "orderbird_internetgatway" {
  #we need vpc id for intergateway to create
  vpc_id = aws_vpc.orderbird_vpc.id
  tags = {
      Name ="igw-${var.project_name}-${var.environment}"
  } 
}


#Add a data source to main.tf to access region information.
data "aws_region" "region_datasource" { }


#public subnet 1

locals {
  len_public_subnets    =length(var.public_subnet_List)
  create_public_subnets = local.len_public_subnets > 0
}


resource "aws_subnet" "public_subnet" {

  count =  local.create_public_subnets && local.len_public_subnets > 0? local.len_public_subnets : 0

  vpc_id                  = aws_vpc.orderbird_vpc.id
  cidr_block              = element(var.public_subnet_List, count.index)

  availability_zone       = element(var.availabilityzonelist, count.index)
  map_public_ip_on_launch = true
 
  tags = {
      Name ="public_subnet-${var.project_name}-${var.environment}-${count.index}"
  } 
}


resource "aws_route_table" "orderbird_public_route_table" {
  count = local.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.orderbird_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.orderbird_internetgatway.id
  }
  tags = {
     Name ="public_route_table-${var.project_name}-${var.environment}"
  }

}

resource "aws_route_table_association" "public_subnet_route_tb_association" {

  count = local.create_public_subnets ? local.len_public_subnets : 0
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.orderbird_public_route_table[0].id
}

#private subnet 1

locals {
  len_private_subnets    =length(var.private_subnet_List)
  create_private_subnets = local.len_private_subnets > 0
}

# create private app subnet az1
resource "aws_subnet" "private_subnet" {
  count =  local.create_private_subnets && local.len_private_subnets > 0 ? local.len_private_subnets : 0

  vpc_id                  = aws_vpc.orderbird_vpc.id
  cidr_block              = element(var.private_subnet_List, count.index)

  availability_zone       = element(var.availabilityzonelist, count.index)
  map_public_ip_on_launch  = false

  tags = {
     Name ="private_subnet-${var.project_name}-${var.environment}-${count.index}"
  }
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? local.len_private_subnets : 1
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "elasticip" {
  count      = local.create_private_subnets && local.len_private_subnets > 0 && local.nat_gateway_count >0 ? local.nat_gateway_count : 0
  vpc        = true
  #domain     = "vpc"
  depends_on = [aws_internet_gateway.orderbird_internetgatway]
}

resource "aws_nat_gateway" "natgateway" {
  count      = local.create_private_subnets && var.enable_nat_gateway && local.len_private_subnets > 0 && local.nat_gateway_count >0  ? local.nat_gateway_count : 0
  subnet_id     = element(aws_subnet.public_subnet.*.id, var.single_nat_gateway ? 0 : count.index)
  allocation_id = element(aws_eip.elasticip[*].id, count.index)

  depends_on = [aws_internet_gateway.orderbird_internetgatway]
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private_route_table" {
  #count = local.create_private_subnets ? 1 : 0
  # There are as many routing tables as the number of NAT gateways
  count = local.create_private_subnets && local.len_private_subnets > 0 && var.enable_nat_gateway ? local.nat_gateway_count : 0
  vpc_id = aws_vpc.orderbird_vpc.id

  route {
    cidr_block     = var.nat_gateway_destination_cidr_block
    nat_gateway_id = element(aws_nat_gateway.natgateway[*].id, count.index)
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private_subnet_route_tb_association" {
  count = local.create_private_subnets && var.enable_nat_gateway  ? local.len_private_subnets : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}




