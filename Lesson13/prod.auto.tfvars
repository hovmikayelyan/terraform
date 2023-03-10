# auto fill parameters for PROD

# to use this, run
#   terraform apply -var-file="prod.auto.tfvars"

region = "eu-central-1"
instance_type = "t2.small"
detailed_monitoring = false

allowed_ports = ["80", "443", "8080"]

common_tags = {
  Owner   = "Hov-TF"
  Project = "Phoenix"
}
