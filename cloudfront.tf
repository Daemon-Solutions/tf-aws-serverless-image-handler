resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_api_gateway_rest_api.rest_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = "Default"
    origin_path = "/image"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = "${var.enabled}"
  comment         = "Created with Terraform"
  is_ipv6_enabled = "${var.ipv6}"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.bucket.id}.s3.amazonaws.com"
    prefix          = "cloudfront"
  }

  aliases = ["${var.aliases}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = "${var.compress}"
    target_origin_id = "Default"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

      headers = ["Accept"]
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "${var.price_class}"

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "${var.404minttl}"
  }

  custom_error_response {
    error_code            = "500"
    error_caching_min_ttl = "${var.500minttl}"
  }

  custom_error_response {
    error_code            = "501"
    error_caching_min_ttl = "${var.501minttl}"
  }

  custom_error_response {
    error_code            = "502"
    error_caching_min_ttl = "${var.502minttl}"
  }

  custom_error_response {
    error_code            = "503"
    error_caching_min_ttl = "${var.503minttl}"
  }

  custom_error_response {
    error_code            = "504"
    error_caching_min_ttl = "${var.504minttl}"
  }

  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "${var.ssl_support_method}"
  }

  web_acl_id = "${var.web_acl_id}"
}
