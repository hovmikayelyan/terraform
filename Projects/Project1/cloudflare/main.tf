# Add a record to the domain

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "example" {
  zone_id = var.cloudflare_zone_id
  name    = "terraform"
  value   = "192.0.2.1"
  type    = "CNAME"
  ttl     = 0
}
