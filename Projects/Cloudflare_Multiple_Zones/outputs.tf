#-------------------------------------------------
#
# Outputs
#
#-------------------------------------------------

output "name_servers" {
  value = cloudflare_zone.domains[*].name_servers
}

output "domains" {
  value = cloudflare_zone.domains[*].zone
}

output "zone_ids" {
  value = cloudflare_zone.domains[*].id
}
