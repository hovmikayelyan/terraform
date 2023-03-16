#-------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

terraform {
  backend "s3" {
    bucket = "hovs-terraform-project"            // Bucket where to SAVE Terraform State
    key    = "globalVars/dirA/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "eu-west-3"                         // Region where bucket created
  }
}


output "company_name" {
  value = "Technamin"
}

output "owner_name" {
  value = "Johannes"
}

output "interests" {
  value = {
    Gym   = "Definetly"
    Yoga  = "Sometimes"
    Music = "ofkos"
  }
}
