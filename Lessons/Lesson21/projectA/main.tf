provider "aws" {
  region = "eu-west-3"
}


module "vpc-default" {
  source = "../modules/aws_network"
}


module "vpc-dev" {
  source               = "github.com/hovmikayelyan/terraform.git//Lesson21/modules/aws_network"
  owner                = "hmik-development"
  env                  = "development"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}

module "vpc-prod" {
  source               = "../modules/aws_network"
  owner                = "hmik-prod"
  env                  = "production"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

module "vpc-test" {
  source               = "../modules/aws_network"
  owner                = "hmik_test_only"
  env                  = "production"
  vpc_cidr             = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs = ["10.20.11.0/24", "10.20.22.0/24"]
}


#===============================

output "prod_public_subnet_ids" {
  value = module.vpc-prod.public_subnet_ids
}
output "prod_private_subnet_ids" {
  value = module.vpc-prod.private_subnet_ids
}

output "dev_public_subnet_ids" {
  value = module.vpc-dev.public_subnet_ids
}
