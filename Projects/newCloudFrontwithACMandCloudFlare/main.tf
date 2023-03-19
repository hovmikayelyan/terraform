#-------------------------------------------------
# Provider - AWS, Cloudflare
#
# This project does things in this order:
# - Creates ACM certificate for provided domains
# - Assigns CNAME records to domains in your cloudflare account
# - Creates a CloudFront Distribution, with all domains as aliases
# - Assigns new CNAME records in your cloudflare account, which are pointing the main-site(@) to created Cloudfront
#
# Made by Hovhannes Mikayelyan
# Thank You!
#-------------------------------------------------

locals {
  domains = split(",", var.domains)
}