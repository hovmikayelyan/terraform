#-------------------------------------------------
#
# Outputs
#
#-------------------------------------------------

output "domains" {
  value = local.domains
}

output "certificate" {
  value = aws_acm_certificate.cert.id
}

output "caching_disabled_id" {
  value = data.aws_cloudfront_cache_policy.CachingDisabled.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "name_servers" {
  value = cloudflare_zone.domains[*].name_servers
}

output "zone_ids" {
  value = cloudflare_zone.domains[*].id
}
