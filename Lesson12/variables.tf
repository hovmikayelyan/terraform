
variable "region" {
  default     = "eu-west-3"
  description = "Please Enter The Region"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Enter instance type"
}

variable "allowed_ports" {
  type        = list(any)
  default     = ["80", "443", "22"]
  description = "which ports enable for instance"
}

variable "detailed_monitoring" {
  type        = bool
  default     = false
  description = "to enable detailed monitoring"
}


variable "common_tags" {
  type = map(any)
  default = {
    Owner   = "Hov-TF"
    Project = "Phoenix"
  }
  description = "common tags to apply to all resources"
}
