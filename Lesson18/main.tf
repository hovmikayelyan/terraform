#-------------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "aws" {
  region = "eu-west-3"
}

variable "aws_users" {
  description = "List of IAM Users to create."
  default     = ["user1", "user2", "user53", "user13"]
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}


output "created_iam_users" {
  value = aws_iam_user.users
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}


output "created_iam_users_custom" {
  value = [
    for item in aws_iam_user.users :
    "Username:${item.name} has ARN: ${item.arn}"
  ]
}

output "created_iam_users_map" {
  description = "Creates a map, index is user's unique_id, the value is the regular id"
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}


#print users when their names is 4 characters only
output "custom_if_length" {
  value = [
    for item in aws_iam_user.users :
    item.name
    if length(item.name) == 5
  ]
}

#--------------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-06b6c7fea532f597e"
  instance_type = "t2.micro"
  tags = {
    Name = "Server N${count.index + 1}"
  }
}


#print nice map with id and public_ip
output "server_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
