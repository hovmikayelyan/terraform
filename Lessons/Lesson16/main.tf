#-------------------------------------------------
# My Terraform
#
# ssm store
# rds
# random string -> keepers
#
# Made by Hov Mikayelyan
#-------------------------------------------------




provider "aws" {
  region = "eu-west-3"
}

variable "name" {
  default = "hov"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
  keepers = {
    "keeper1" = var.name
    # "keeper2" = var.something
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master pswd for  mysql"
  type        = "SecureString"
  value       = random_string.rds_password.result
}


data "aws_ssm_parameter" "my_rds_pswd" {
  name = "/prod/mysql"

  depends_on = [
    aws_ssm_parameter.rds_password
  ]
}


resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 10
  storage_type         = "gp2"
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = data.aws_ssm_parameter.my_rds_pswd.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}


output "my_pswd" {
  value     = data.aws_ssm_parameter.my_rds_pswd.value
  sensitive = true
}
