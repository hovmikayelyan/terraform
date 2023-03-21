#-------------------------------------------------
# Provider - AWS, Cloudflare
#
# This project does things in this order:
# - Creates Zones in Cloudflare
#
# Made by Hovhannes Mikayelyan
# Thank You!
#-------------------------------------------------

locals {
  domains = split(",", var.domains)
}