# This is the provider which will download provider related API
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


#we use the provider to interact with cloud here AWS
provider "aws" {
  region     = "eu-central-1"
  profile = "terraform-user"
}
