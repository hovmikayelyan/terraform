#-------------------------------------------------
# My Terraform
#
# data
#
# Made by Hov Mikayelyan
#-------------------------------------------------


provider "aws" {
  region = "eu-west-3"
}

#-------------------------------------------

data "aws_availability_zones" "working" {}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}


#-------------------------------------------


data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

#-------------------------------------------

data "aws_region" "current" {}

output "data_aws_region" {
  value = data.aws_region.current.name
}

#-------------------------------------------

data "aws_vpcs" "my_vpcs" {}

output "data_my_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

#-------------------------------------------


resource "aws_subnet" "my_subnet" {
  vpc_id            = data.aws_vpcs.my_vpcs.ids[0]
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.2.0.0/24"

  tags = {
    Name    = "Subnet-A in ${data.aws_availability_zones.working.names[1]}"
    Account = "In account: ${data.aws_caller_identity.current.account_id}"
    Region  = "In region: ${data.aws_region.current.description}"
  }
}
