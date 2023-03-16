#-------------------------------------------------
# My Terraform
#
# User Variables from Remote State
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "hovs-terraform-project"            // Bucket where to SAVE Terraform State
    key    = "globalVars/dirA/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "eu-west-3"                         // Region where bucket created
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner_name   = data.terraform_remote_state.global.outputs.owner_name
  interests    = data.terraform_remote_state.global.outputs.interests
}

resource "aws_security_group" "test" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"


  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.interests, {
    Hajox = "barev"
  })

  provisioner "local-exec" {
    command = "print('My name is ${local.owner_name}')"
    interpreter = [
      "python", "-c"
    ]
  }
}
