#-------------------------------------------------
# Provider - AWS
#
# Create ACM certificate for provided domains
#
# Made by Hov Mikayelyan
#-------------------------------------------------

resource "aws_acm_certificate" "cert" {
  domain_name       = element(var.domains, 0)
  validation_method = "DNS"

  tags = {
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}