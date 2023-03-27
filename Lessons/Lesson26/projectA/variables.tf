variable "vpc_setting" {
  default = {
    prod = "10.10.0.0/16"
    stag = "10.20.0.0/16"
    dev  = "10.30.0.0/16"
  }
}

variable "region" {
  default = "eu-west-1"
  type    = string

  validation {
    condition     = substr(var.region, 0, 3) == "eu-"
    error_message = "Must be a region from AWS WUROPE, like \"eu-\"."
  }
}

