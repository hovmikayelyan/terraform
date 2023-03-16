
region = "eu-west-3"
instance_type = "t3.micro"
detailed_monitoring = false

allowed_ports = ["80", "443", "22"]

common_tags = {
  Owner   = "Hov-TF"
  Project = "Phoenix"
}
