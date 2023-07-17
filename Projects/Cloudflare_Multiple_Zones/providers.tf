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
  api_token = var.CF_TOKEN
  account_id = var.CF_ACC_ID
}
