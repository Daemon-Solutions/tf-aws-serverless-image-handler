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

# Image handler Lambda
variable "auto_webp" {
  description = "Automatically return Webp format images based on the client Accept header."
  default     = "False"
}

variable "preserve_exif_info" {
  description = "Preserves exif information in generated images. Increases image size."
  default     = "False"
}

variable "allow_unsafe_url" {
  description = "Allow unencrypted URL's."
  default     = "True"
}

variable "cors_origin" {
  description = "Value returned by the API in the Access-Control-Allow-Origin header. A star (*) value will support any origin."
  default     = "*"
}

variable "enable_cors" {
  description = "Enable API Cross-Origin Resource Sharing (CORS) support."
  default     = "No"
}

variable "log_level" {
  description = "Lambda image handler log level."
  default     = "INFO"
}

variable "security_key" {
  description = "Key to use to generate safe URL's."
  default     = ""
}

variable "send_anonymous_data" {
  description = "Send anonymous usage data to Amazon."
  default     = "No"
}

variable "aws_endpoint" {
  description = "AWS s3 endpoint per region."

  default = {
    us-east-1      = "https://s3.amazonaws.com"
    us-east-2      = "https://s3.us-east-2.amazonaws.com"
    us-west-1      = "https://s3-us-west-1.amazonaws.com"
    us-west-2      = "https://s3-us-west-2.amazonaws.com"
    ca-central-1   = "https://s3.ca-central-1.amazonaws.com"
    eu-west-1      = "https://s3-eu-west-1.amazonaws.com"
    eu-central-1   = "https://s3.eu-central-1.amazonaws.com"
    eu-west-2      = "https://s3.eu-west-2.amazonaws.com"
    eu-west-3      = "https://s3.eu-west-3.amazonaws.com"
    ap-northeast-1 = "https://s3-ap-northeast-1.amazonaws.com"
    ap-northeast-2 = "https://s3.ap-northeast-2.amazonaws.com"
    ap-southeast-1 = "https://s3-ap-southeast-1.amazonaws.com"
    ap-southeast-2 = "https://s3-ap-southeast-2.amazonaws.com"
    ap-south-1     = "https://s3.ap-south-1.amazonaws.com"
    sa-east-1      = "https://s3-sa-east-1.amazonaws.com"
  }
}

# CloudFront
variable "cf_acm_certificate_arn" {
  description = "ACM certificate to use with the created CloudFront distribution."
}

variable "cf_aliases" {
  description = "Aliases for the CloudFront distribution."
  type        = "list"
}

variable "cf_enabled" {
  description = "State of the CloudFront distribution."
  default     = "true"
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
variable "log_retention" {
  description = "Log retention in days."
  default     = 30
}

variable "logs_filter_pattern" {
  description = "Metric filter to filter logs sent from CloudWatch to s3 or Elasticsearch."
  default     = "?\"[INFO]\" ?\"[WARNING]\" ?\"[ERROR]\""
}

variable "enable_s3_logs" {
  description = "Enable sending Lambda CloudWatch logs to s3 via Firehose."
  default     = false
}

variable "enable_es_logs" {
  description = "Enable sending Lambda logs to Elasticsearch via Firehose."
  default     = false
}

variable "es_logs_domain" {
  description = "Elasticsearch domain ARN to send CloudWatch logs to."
  default     = ""
}

variable "es_logs_index_name" {
  description = "Elasticsearch index name for CloudWatch logs."
  default     = ""
}

variable "es_logs_type_name" {
  description = "Name of the log type sent to Elasticsearch from CloudWatch logs."
  default     = ""
}
