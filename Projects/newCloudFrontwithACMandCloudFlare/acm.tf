#-------------------------------------------------
# Provider - AWS
#
# Create Certificate
#
#-------------------------------------------------

resource "aws_acm_certificate" "cert" {
  provider                  = aws.ACM
  domain_name               = element(local.domains, 0)
  validation_method         = "DNS"
  subject_alternative_names = local.domains

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Description = "TF-Created"
  }
}
