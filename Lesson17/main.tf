#-------------------------------------------------
# My Terraform
#
# Conditions and Lookups
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

variable "env" {
  default = "prod"
}

variable "prod_owner" {
  default = "hmik"
}

variable "dev_owner" {
  default = "dev_user"
}

variable "ec2_size" {
  default = {
    "prod" = "t2.small"
    "dev"  = "t2.micro"
  }
}

variable "allow_port_lisr" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "my_webserver" {
  ami = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  # instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  instance_type = var.ec2_size[var.env]

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.dev_owner
  }
}


resource "aws_instance" "my_webserver2" {
  ami           = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.dev_owner
  }
}


resource "aws_instance" "my_dbserver" {
  count         = var.env == "prod" ? 1 : 0
  ami           = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type = var.ec2_size[var.env]

  tags = {
    Name  = "${var.env}-server-db"
    Owner = var.env == "prod" ? var.prod_owner : var.dev_owner
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_lisr, var.env)
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "Dynamic SG build by Terraform"
    Owner = "Hov-TF"
  }
}
