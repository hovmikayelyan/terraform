#------------------------------
#
# All Required Variables
#
#------------------------------

variable "CF_USR" {}
variable "CF_PWD" {}
variable "CF_ACC_ID" {}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

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

