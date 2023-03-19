#-------------------------------------------------
# Provider - AWS
#
# Create Cloudfront
#
#-------------------------------------------------

data "aws_cloudfront_cache_policy" "CachingDisabled" {
  name = "Managed-CachingDisabled"
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [cloudflare_record.acm_records]

  create_duration = "60s"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [
    time_sleep.wait_60_seconds
  ]

  origin {
    domain_name = "${var.bucket_name}.s3.${var.region}.amazonaws.com"
    origin_id   = var.bucket_name
  }
  http_version        = "http2and3"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = local.domains

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    viewer_protocol_policy = "allow-all"
    cache_policy_id        = data.aws_cloudfront_cache_policy.CachingDisabled.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }


  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Description = "TF-Created"
  }

}


