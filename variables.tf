# General
variable "name" {
  description = "Custom name for created resources."
  default     = "tf-aws-serverless-image-handler"
}

variable "random_byte_length" {
  description = "The byte length of the random id generator used for unique resource names."
  default     = 4
}

variable "origin_bucket" {
  description = "Bucket where the source images reside."
}

variable "log_bucket" {
  description = "Bucket where to store logs."
}

# Image handler Lambda
variable "auto_webp" {
  description = "Automatically return Webp format images based on the client Accept header."
  default     = "False"
}

variable "cors_origin" {
  description = "Value returned by the API in the Access-Control-Allow-Origin header. A star (*) value will support any origin."
  default     = "*"
}

variable "enable_cors" {
  description = "Enable API Cross-Origin Resource Sharing (CORS) support."
  default     = "No"
}

variable "memory_size" {
  description = "Memory to assign to the image Lambda function."
  default     = "1536"
}

variable "rewrite_match_pattern" {
  description = "Regex for matching custom image requests using the rewrite function."
  default     = ""
}

variable "rewrite_substitution" {
  description = "Substitution string for matching custom image requests using the rewrite function."
  default     = ""
}

variable "safe_url" {
  description = "Toggle to enable safe URL's."
  default     = "False"
}

variable "security_key" {
  description = "Key to use to generate safe URL's."
  default     = ""
}

variable "timeout" {
  description = "Timeout in seconds of the image Lambda function."
  default     = "20"
}

# CloudFront
variable "cf_acm_certificate_arn" {
  description = "ACM certificate to use with the created CloudFront distribution."
}

variable "cf_aliases" {
  description = "Aliases for the CloudFront distribution."
  type        = list(string)
}

variable "cf_enabled" {
  description = "State of the CloudFront distribution."
  default     = "true"
}

variable "cf_s3_origin" {
  description = "Additional s3 origins for the created CloudFront distribution."
  default     = []
  type = list(object({
    domain_name            = string
    origin_id              = string
    origin_access_identity = string
  }))
}

variable "cf_ordered_cache_behavior" {
  description = "Additional cache behaviors for the created CloudFront distribution."
  default     = []
  type = list(object({
    path_pattern                      = string
    allowed_methods                   = list(string)
    cached_methods                    = list(string)
    compress                          = string
    target_origin_id                  = string
    forward_query_string              = string
    forward_query_string_cache_keys   = list(string)
    forward_cookies                   = string
    forward_cookies_whitelisted_names = list(string)
    forward_headers                   = list(string)
    viewer_protocol_policy            = string
    min_ttl                           = number
    default_ttl                       = number
    max_ttl                           = number
    trusted_signers                   = list(string)
    smooth_streaming                  = string
    field_level_encryption_id         = string
  }))
}

variable "cf_compress" {
  description = "Enable automatic response compression."
  default     = "false"
}

variable "cf_min_ttl" {
  description = "Minimum TTL in seconds."
  default     = "0"
}

variable "cf_default_ttl" {
  description = "Default TTL in seconds."
  default     = "86400"
}

variable "cf_log_prefix" {
  description = "CloudFront log prefix."
  default     = "cloudfront/"
}

variable "cf_max_ttl" {
  description = "Maximum TTL in seconds."
  default     = "31536000"
}

variable "cf_price_class" {
  description = "Price class of the CloudFront distribution."
  default     = "PriceClass_All"
}

variable "cf_404_min_ttl" {
  description = "Minumum TTL of 404 responses."
  default     = "60"
}

variable "cf_500_min_ttl" {
  description = "Minumum TTL of 500 responses."
  default     = "0"
}

variable "cf_501_min_ttl" {
  description = "Minumum TTL of 501 responses."
  default     = "0"
}

variable "cf_502_min_ttl" {
  description = "Minumum TTL of 502 responses."
  default     = "0"
}

variable "cf_503_min_ttl" {
  description = "Minumum TTL of 503 responses."
  default     = "0"
}

variable "cf_504_min_ttl" {
  description = "Minumum TTL of 504 responses."
  default     = "0"
}

variable "cf_ssl_support_method" {
  description = "Method by which CloudFront serves HTTPS requests."
  default     = "sni-only"
}

variable "cf_ipv6" {
  description = "Enable IPv6 on the CloudFront distribution."
  default     = "true"
}

variable "web_acl_id" {
  description = "WAF ACL to use with the CloudFront distribution."
  default     = ""
}

# CloudWatch Logs
variable "cw_log_prefix" {
  description = "CloudWatch log prefix."
  default     = "cloudwatch/"
}

variable "log_retention" {
  description = "Log retention in days."
  default     = 30
}
