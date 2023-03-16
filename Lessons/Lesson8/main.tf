#-------------------------------------------------
# My Terraform
#
# depends_on
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server_sg.id]

  tags = {
    Name  = "Server-WEB"
  }

  depends_on = [
    aws_instance.my_server_db
  ]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server_sg.id]

  tags = {
    Name  = "Server-APP"
  }

  depends_on = [
    aws_instance.my_server_db, aws_instance.my_server_web
  ]
}

resource "aws_instance" "my_server_db" {
  ami                    = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server_sg.id]

  tags = {
    Name  = "Server-DB"
  }
}

resource "aws_security_group" "my_server_sg" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
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
