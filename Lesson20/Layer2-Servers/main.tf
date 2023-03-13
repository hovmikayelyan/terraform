#-------------------------------------------------
# My Terraform
#
# get tfvars from s3, create this project's in s3 also
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

terraform {
  backend "s3" {
    bucket = "hovs-terraform-project"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-west-3"
  }
}

#------------------------------------------------------

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "hovs-terraform-project"
    key    = "dev/network/terraform.tfstate"
    region = "eu-west-3"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }
}

#------------------------------------------------------

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.524/latest/meta-data/local-ipv4`
echo "<h1 style='color: blue;'>Hello world from $(hostname -f) > WebServer > IP: $myip <br> Build By TF with Remote State </h1>" > /var/www/html/index.html
systemctl start httpd
chkconfig httpd on
EOF

  tags = {
    "Name" = "WebServer"
  }
}



resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id


  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
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

