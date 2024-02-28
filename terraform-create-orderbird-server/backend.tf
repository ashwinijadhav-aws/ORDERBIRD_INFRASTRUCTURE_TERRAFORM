#create VPC


# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "terraform-create-orderbird-server-bucket"
    key       = "teraform-project.tfstate"
    region    = "eu-central-1"
    profile   = "terraform-user"
  }
}
