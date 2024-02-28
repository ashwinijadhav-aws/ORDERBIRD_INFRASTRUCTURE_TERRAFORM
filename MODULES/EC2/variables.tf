variable "instance_count" {
    description = "number of EC2 machine"
    type = number
    default=0
}

variable "instance_type" {
    type = string
}

variable "ami" {
    type = string
}

variable "scriptname" {
    type = string
}


variable "subnet_ids" {
  description = "Subnet IDs for EC2 instances"
  type        = list(string)
  # if deafult value is set to null this variable is considered as optional variable
   default=null
  
}

variable "securitygroup_ids" {
  description = "securitygroup for EC2 instances"
  type        = list(string)
  # if deafult value is set to null this variable is considered as optional variable
  default=null
  
}


variable tags{
    type=map
    default={}
}