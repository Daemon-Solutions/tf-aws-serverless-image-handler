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

  dynamic "origin" {
    for_each = var.cf_s3_origin
    content {
      domain_name = origin.value["domain_name"]
      origin_id   = origin.value["origin_id"]
      s3_origin_config {
        origin_access_identity = origin.value["origin_access_identity"]
      }
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

  dynamic "ordered_cache_behavior" {
    for_each = var.cf_ordered_cache_behavior
    content {
      path_pattern     = ordered_cache_behavior.value["path_pattern"]
      allowed_methods  = ordered_cache_behavior.value["allowed_methods"]
      cached_methods   = ordered_cache_behavior.value["cached_methods"]
      compress         = ordered_cache_behavior.value["compress"]
      target_origin_id = ordered_cache_behavior.value["target_origin_id"]
      forwarded_values {
        query_string            = ordered_cache_behavior.value["forward_query_string"]
        query_string_cache_keys = ordered_cache_behavior.value["forward_query_string_cache_keys"]
        cookies {
          forward           = ordered_cache_behavior.value["forward_cookies"]
          whitelisted_names = ordered_cache_behavior.value["forward_cookies_whitelisted_names"]
        }
        headers = ordered_cache_behavior.value["forward_headers"]
      }
      viewer_protocol_policy    = ordered_cache_behavior.value["viewer_protocol_policy"]
      min_ttl                   = ordered_cache_behavior.value["min_ttl"]
      default_ttl               = ordered_cache_behavior.value["default_ttl"]
      max_ttl                   = ordered_cache_behavior.value["max_ttl"]
      trusted_signers           = ordered_cache_behavior.value["trusted_signers"]
      smooth_streaming          = ordered_cache_behavior.value["smooth_streaming"]
      field_level_encryption_id = ordered_cache_behavior.value["field_level_encryption_id"]
    }
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

