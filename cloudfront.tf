resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_api_gateway_rest_api.rest_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = "Default"
    origin_path = "/image"

    custom_header {
      name  = "x-api-key"
      value = aws_api_gateway_api_key.key.value
    }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = var.cf_enabled
  comment         = "Created with Terraform"
  is_ipv6_enabled = var.cf_ipv6

  logging_config {
    include_cookies = false
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    prefix          = var.cf_log_prefix
  }

  aliases = var.cf_aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = var.cf_compress
    target_origin_id = "Default"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

      headers = ["Accept"]
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = var.cf_min_ttl
    default_ttl            = var.cf_default_ttl
    max_ttl                = var.cf_max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = var.cf_price_class

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = var.cf_404_min_ttl
  }

  custom_error_response {
    error_code            = "500"
    error_caching_min_ttl = var.cf_500_min_ttl
  }

  custom_error_response {
    error_code            = "501"
    error_caching_min_ttl = var.cf_501_min_ttl
  }

  custom_error_response {
    error_code            = "502"
    error_caching_min_ttl = var.cf_502_min_ttl
  }

  custom_error_response {
    error_code            = "503"
    error_caching_min_ttl = var.cf_503_min_ttl
  }

  custom_error_response {
    error_code            = "504"
    error_caching_min_ttl = var.cf_504_min_ttl
  }

  viewer_certificate {
    acm_certificate_arn            = var.cf_acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = var.cf_ssl_support_method
  }

  web_acl_id = var.web_acl_id
}

