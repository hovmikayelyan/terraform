#--------------------------------------------------------
# My Terraform
#--------------------------------------------------------
# data aws_ami
#   - Find latest ami id of
#     * Ubuntu 
#     * Amazon Linux 2
#     * Windows Server
#--------------------------------------------------------
# Made by Hov Mikayelyan
#--------------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

data "aws_ami" "latest_amznLinux" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

}

output "latest_amzn_linux_id" {
  value = data.aws_ami.latest_amznLinux.id
}
output "latest_amzn_linux_name" {
  value = data.aws_ami.latest_amznLinux.name
}


data "aws_ami" "latestUbuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


output "latest_ubuntu_linux_id" {
  value = data.aws_ami.latestUbuntu.id
}
output "latest_ubuntul_inux_name" {
  value = data.aws_ami.latestUbuntu.name
}


resource "aws_instance" "my_webserver" {
  ami           = data.aws_ami.latest_amznLinux.id # Amazon Linux 2 AMI PARIS
  instance_type = "t2.micro"
}
