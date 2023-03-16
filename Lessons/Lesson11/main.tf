#----------------------------------------------------------
# Provision Highly Available Web in any Region Default VPC
# Create:
#     - Security Group for Web Server
#     - Launch Configuration with Auto AMI Lookup
#     - ASG using 2 AZ
#     - Classic LB in 2 AZ
#
# Made by @hovmikayelyan
#----------------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_amznLinux" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

}

#----------------------------------------------------------

resource "aws_security_group" "web" {
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

resource "aws_launch_configuration" "web" {
  # name          = "WebServer-HighlyAvailable-LC"
  name_prefix   = "WebServer-HighlyAvailable-LC-"
  image_id      = data.aws_ami.latest_amznLinux.id
  instance_type = "t2.micro"

  security_groups = [aws_security_group.web.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name    = "John",
    l_name    = "Mikayelyan",
    interests = ["music", "movies", "sport"]
  })

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 2
  min_size             = 1
  desired_capacity     = 2
  min_elb_capacity     = 1
  health_check_type    = "ELB" #or EC2
  vpc_zone_identifier  = [aws_default_subnet.default_az_A.id, aws_default_subnet.default_az_A.id]
  load_balancers       = [aws_elb.web.name]


  dynamic "tag" {
    for_each = {
      Name  = "WebServer in ASG"
      Owner = "hovm"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HighlyAvailable-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    "Name" = "WebServer-HighlyAvailable-ELB"
  }
}

resource "aws_default_subnet" "default_az_A" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az_B" {
  availability_zone = data.aws_availability_zones.available.names[1]
}


output "web_LB_url" {
  value = aws_elb.web.dns_name
}
