#-------------------------------------------------
# Provider - Cloudflare
#
# Create zones in Cloudflare, then afte AWS resources creation, push records into zones
#
#-------------------------------------------------

resource "cloudflare_zone" "domains" {
  count      = length(local.domains)
  zone       = element(local.domains, count.index)
  account_id = var.CF_ACC_ID
}

data "cloudflare_zones" "all_zones" {
  count = length(local.domains)
  filter {
    name = element(local.domains, count.index)
  }

  depends_on = [
    cloudflare_zone.domains
  ]
}

#=======================================================================

resource "cloudflare_zone_settings_override" "domain" {
  count   = length(local.domains)
  zone_id = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  settings {
    minify {
      css  = var.minify_css
      js   = var.minify_js
      html = var.minify_html
    }
    always_use_https = var.always_use_https
    ssl              = var.ssl
    security_header {
      enabled            = true
      preload            = true
      max_age            = 31536000
      include_subdomains = true
      nosniff            = true
    }
    min_tls_version    = var.min_tls_version
    always_online      = var.always_online
    hotlink_protection = var.hotlink_protection
  }
}

resource "cloudflare_page_rule" "www" {
  count    = length(local.domains)
  zone_id  = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  target   = "www.${element(local.domains, count.index)}/*"
  priority = 1

  actions {
    forwarding_url {
      url         = "https://${element(local.domains, count.index)}/$1"
      status_code = 301
    }
  }
}

resource "cloudflare_ruleset" "transform_modify_response_headers" {
  count       = length(local.domains)
  zone_id     = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  name        = "Transform Rule "
  description = ""
  kind        = "zone"
  phase       = "http_response_headers_transform"
  rules {
    action = "rewrite"
    action_parameters {
      headers {
        name      = "Cache-control"
        operation = "set"
        value     = "no-store"
      }
      headers {
        name      = "Pragma"
        operation = "set"
        value     = "no-cache"
      }
    }
    expression  = "(http.request.uri.path eq \"/\")"
    description = "CacheDisable"
    enabled     = true
  }
}

resource "cloudflare_record" "www" {
  count   = length(local.domains)
  zone_id = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  name    = "www"
  value   = "@"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
