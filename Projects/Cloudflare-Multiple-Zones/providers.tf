#-------------------------------------------------
#
# Providers
#
#-------------------------------------------------

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
provider "cloudflare" {
  email   = var.CF_USR
  api_key = var.CF_PWD
}
