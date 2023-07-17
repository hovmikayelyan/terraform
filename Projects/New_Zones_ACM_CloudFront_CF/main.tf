#-------------------------------------------------
# Provider - AWS, Cloudflare
#
# This project does things in this order:
# - Creates zones in Cloudflare
# - Creates ACM certificate for provided domains > zones
# - Assigns CNAME records to domains in your cloudflare account
# - Creates a CloudFront Distribution, with all domains as aliases
# - Assigns new CNAME records in your cloudflare account, which are pointing the main-site(@) to created Cloudfront
#
# Made by Hovhannes Mikayelyan
# Thank You!
#-------------------------------------------------

locals {
  domains = split(",", var.domains)

  acm_data = [
    for cert in aws_acm_certificate.cert.domain_validation_options : {
      name       = cert.resource_record_name
      value      = cert.resource_record_value
      type       = cert.resource_record_type
      zone_index = index(cloudflare_zone.domains[*].zone, cert.domain_name)
    }
  ]
}
