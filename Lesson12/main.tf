#variables


provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amznLinux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

}

resource "aws_instance" "my_webserver" {
  ami             = data.aws_ami.latest_amznLinux.id # Amazon Linux 2 AMI PARIS
  instance_type   = var.instance_type
  security_groups = [aws_security_group.my_webserver.id]

  monitoring = var.detailed_monitoring

  tags = var.common_tags
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Owner"]}'s Dynamic SG build by Terraform"
  })
}
