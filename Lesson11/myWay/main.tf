#----------------------------------------------------------
# Provision Highly Available Web in any Region Default VPC
# Create:
#     - Security Group for Web Server
#     - Launch Template with Auto AMI Lookup
#     - ASG using 2 AZ
#     - ALB in 2 AZ
#
# Made by @hovmikayelyan


# DOESNT WORK, NEED TO FIX!!!
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


data "aws_vpcs" "my_vpcs" {}

output "data_my_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
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



resource "aws_lb_target_group" "web" {
  name        = "WebServer-HA-TargetGroup"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpcs.my_vpcs.ids[0]

}

resource "aws_launch_template" "web" {
  name = "WebServer-HighlyAvailable-LaunchTemplate"

  user_data = filebase64("/user_data.sh")

  image_id      = data.aws_ami.latest_amznLinux.id
  instance_type = "t2.micro"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name              = "WebServer-HighlyAvailable-ASG"
  target_group_arns = [aws_lb_target_group.web.arn]
  
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  max_size            = 2
  min_size            = 1
  desired_capacity    = 2
  health_check_type   = "EC2" #or EC2
  vpc_zone_identifier = [aws_default_subnet.default_az_A.id, aws_default_subnet.default_az_B.id]


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

  depends_on = [
    aws_launch_template.web
  ]
}


resource "aws_lb" "web" {
  name               = "WebServer-HighlyAvailable-ELB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_default_subnet.default_az_A.id, aws_default_subnet.default_az_B.id]

  enable_deletion_protection = false

}


resource "aws_default_subnet" "default_az_A" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az_B" {
  availability_zone = data.aws_availability_zones.available.names[1]
}


output "web_LB_url" {
  value = aws_lb.web.dns_name
}
