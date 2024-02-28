#create EC2 instance in the given VPC 


#EC2
data "aws_ami" "amazon_linux_datasource" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

 resource "aws_instance" "EC2-Machine" {
  count                   = var.instance_count== 0 ? 1 : var.instance_count
 # ami                     = data.aws_ami.amazon_linux_datasource.id
   ami                     = var.ami
  key_name                = "FRANKFURT_KEY_PAIR"
  instance_type           = var.instance_type
  subnet_id               = var.subnet_ids==null ? null : element(var.subnet_ids, count.index)
  vpc_security_group_ids      = var.securitygroup_ids
  user_data = file("${path.module}/${var.scriptname}")
  tags = var.tags
  
}

