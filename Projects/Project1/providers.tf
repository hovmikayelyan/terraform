terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
provider "cloudflare" {
  email      = var.email
  api_key    = var.api_key
  account_id = var.account_id
}

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.acm_region
  alias = "ACM"
}
