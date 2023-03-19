#-------------------------------------------------
# Provider - AWS
#
# Push records into zones
#
#-------------------------------------------------

data "cloudflare_zones" "all_zones" {
  count = length(local.domains)
  filter {
    name = element(local.domains, count.index)
  }
}

resource "cloudflare_record" "acm_records" {
  count   = length(local.domains)
  zone_id = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  name    = element(tolist(aws_acm_certificate.cert.domain_validation_options), count.index).resource_record_name
  value   = element(tolist(aws_acm_certificate.cert.domain_validation_options), count.index).resource_record_value
  type    = element(tolist(aws_acm_certificate.cert.domain_validation_options), count.index).resource_record_type
  ttl     = 0
}

resource "cloudflare_record" "cloudfront_records" {
  count   = length(local.domains)
  zone_id = element(data.cloudflare_zones.all_zones, count.index).zones[0].id
  name    = "@"
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 0
}
