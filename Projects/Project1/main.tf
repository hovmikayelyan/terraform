#-------------------------------------------------
# Provider - AWS
#
# Create ACM certificate for provided domains
#
# Made by Hov Mikayelyan
#-------------------------------------------------

locals {
  domains = split(",", var.domains)
}

