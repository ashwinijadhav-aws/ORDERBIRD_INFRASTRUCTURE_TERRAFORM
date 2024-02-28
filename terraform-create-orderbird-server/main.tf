

module "terraform_vpc_2" {
  source  = "/../MODULES/VPC"
  vpc_cidr = var.vpc_cidr
  region =var.region

  availabilityzonelist   = var.availabilityzonelist
  private_subnet_List = var.private_subnet_List
  public_subnet_List  = var.public_subnet_List
  project_name = var.project_name

}

  #Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins_security_group"
  description = "Allow TCP/80 & TCP/22"
  #vpc_id = module.terraform_vpc_2.orderbird_vpc_vpc_id
  vpc_id="vpc-08ad88ce79279b3b3"
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


  #Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "sonarqube_security_group" {
  name        = "sonarqube_security_group"
  description = "Allow TCP/80 & TCP/22"
  vpc_id = "vpc-08ad88ce79279b3b3"
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  #Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "minikube_security_group" {
  name        = "minikube_security_group"
  description = "Allow TCP/80 & TCP/22"
  #vpc_id = module.terraform_vpc_2.orderbird_vpc_vpc_id
  vpc_id="vpc-08ad88ce79279b3b3"
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "allow traffic from TCP/80"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "create-jenkins-server" {
    source= "../MODULES/EC2"
    instance_count = var.instance_count
  #  subnet_ids         = module.terraform_vpc_2.public_subnet_list_output[*]
    ami="ami-023432ac84225fefd"
    scriptname="sonarqube-server-script.sh"
    instance_type = "t2.medium"
    securitygroup_ids = [aws_security_group.jenkins_security_group.id]
    tags = var.tags
}

module "create-minikube-server" {
    source= "../MODULES/EC2"
    instance_count = var.instance_count
   # subnet_ids         = module.terraform_vpc_2.public_subnet_list_output[*]
    ami="ami-0d118c6e63bcb554e"
    scriptname="minikube-server-script.sh"
    instance_type = "t2.medium"
    securitygroup_ids = [aws_security_group.minikube_security_group.id]
    tags = var.tags
}


module "create-sonarqube-server" {
    source= "../MODULES/EC2"
    instance_count = var.instance_count
   # subnet_ids         = module.terraform_vpc_2.public_subnet_list_output[*]
    ami="ami-023432ac84225fefd"
    scriptname="sonarqube-server-script.sh"
    instance_type = "t2.small"
    securitygroup_ids = [aws_security_group.sonarqube_security_group.id]
    tags = var.tags
}



