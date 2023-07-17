#------------------------------
#
# All Required Variables
#
#------------------------------


variable "CF_TOKEN" {
  sensitive = true
}
variable "CF_ACC_ID" {}

variable "AWS_ACCESS_KEY_ID" {
  sensitive = true
}
variable "AWS_SECRET_ACCESS_KEY" {
  sensitive = true
}

variable "domains" {
  description = "Please Enter All domains to start the process"
}
variable "bucket_name" {
  description = "Please Enter the origin to start the process"
}

variable "region" {}

variable "acm_region" {
  description = "Region for AWS ACM"
}

variable "minify_css" {}
variable "minify_html" {}
variable "minify_js" {}

variable "always_use_https" {}
variable "ssl" {}

variable "min_tls_version" {}
variable "always_online" {}
variable "hotlink_protection" {}
