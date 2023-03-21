#-------------------------------------------------
#
# Outputs
#
#-------------------------------------------------

output "zones" {
  value = data.cloudflare_zones.all_zones
}

output "name_servers" {
  value = cloudflare_zone.domains[*].name_servers
}

output "id" {
  value = cloudflare_zone.domains[*].id
}
