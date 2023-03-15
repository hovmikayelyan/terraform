provider "aws" {
  region = "eu-west-3"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "hovs-terraform-project"
    key    = "another/network.tfstate"
    region = "eu-west-3"
  }
}


terraform {
  backend "s3" {
    bucket = "hovs-terraform-project"
    key    = "another/servers.tfstate"
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

resource "aws_instance" "dev_linux" {
  ami             = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.dev.id}"]
  subnet_id       = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
}

resource "aws_security_group" "dev" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
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
    Name = "allow_tls"
  }

}
