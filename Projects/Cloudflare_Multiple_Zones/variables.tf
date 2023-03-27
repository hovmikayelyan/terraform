#------------------------------
#
# All Required Variables
#
#------------------------------

variable "CF_USR" {
  sensitive = true
}
variable "CF_PWD" {
  sensitive = true
}
variable "CF_ACC_ID" {}

variable "domains" {
  description = "Please Enter All domains to start the process"
}

variable "minify_css" {}
variable "minify_html" {}
variable "minify_js" {}

variable "always_use_https" {}
variable "ssl" {}

variable "min_tls_version" {}
variable "always_online" {}
variable "hotlink_protection" {}
