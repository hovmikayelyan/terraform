#-------------------------------------------------
# My Terraform
#
# output
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-06b6c7fea532f597e" # Amazon Linux 2 AMI PARIS
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name    = "John",
    l_name    = "Mikayelyan",
    interests = ["music", "movies", "sport"]
  })

  tags = {
    Name  = "WebServer build by Terraform"
    Owner = "Hov-TF"
  }

  lifecycle {
    prevent_destroy = false
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "Dynamic Security Group"
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

output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "owner_id" {
  value = aws_security_group.my_webserver.owner_id
}
