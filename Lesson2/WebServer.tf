#-------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {}

resource "aws_instance" "my_webserver" {
  count                  = 1
  ami                    = "ami-0d8f9265cd415c863" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.524/latest/meta-data/local-ipv4`
echo "<h1 style='color: blue;'>Hello world from $(hostname -f) > WebServer > IP: $myip <br> Build By TF </h1>" > /var/www/html/index.html
systemctl start httpd
chkconfig httpd on
EOF

  tags = {
    Name  = "WebServer build by Terraform"
    Owner = "Hov-TF"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Security Group for WebServer"

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


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

  tags = {
    Name  = "WebServer SG build by Terraform"
    Owner = "Hov-TF"
  }
}
