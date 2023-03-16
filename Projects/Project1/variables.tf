variable "domains" {
  default     = []
  description = "Please Enter All domains to start the process"
}

variable "env" {
  default = "Stg"
}

variable "cloudflare_zone_id" {
  default     = ""
  description = "Please Enter All domains to start the process"
}

variable "cloudflare_api_token" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}

variable "acm_region" {
  default = "us-east-1"
  description = "Region for AWS ACM"
}