#-------------------------------------------------
# My Terraform
#
# Provision Resources in Multiple AWS Regions / Accounts
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"

  assume_role {
    role_arn     = "arn:aws:iam::4568797/:role/"
    session_name = "afddsadsadsasad"
  }
}
provider "aws" {
  region = "us-east-1"
  alias  = "USA"

  access_key = "yyyyyyyyyyyyyy"
  secret_key = "xxxxxxxxxxxxxx"
}

resource "aws_instance" "my_webserver" {
  ami           = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type = "t2.micro"

  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "usa_webserver" {
  # specifying the region
  provider      = aws.USA
  ami           = data.aws_ami.latest_amznLinux.id # Amazon Linux 2 AMI Virginia
  instance_type = "t2.micro"

  tags = {
    Name = "USA Server"
  }
}

data "aws_ami" "usa_amznLinux" {
  provider    = aws.USA
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

}

