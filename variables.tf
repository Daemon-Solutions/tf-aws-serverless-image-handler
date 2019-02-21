variable "name" {
  default = "tf-aws-serverless-image-handler"
}

variable "random_byte_length" {
  description = "The byte length of the random id generator used for unique resource names."
  default     = 4
}

variable "origin_bucket" {}

## Image Lambda
variable "allow_unsafe_url" {
  default = "true"
}

variable "cors_origin" {
  default = "*"
}

variable "enable_cors" {
  default = "No"
}

variable "log_level" {
  default = "INFO"
}

variable "send_anonymous_data" {
  default = "No"
}

variable "aws_endpoint" {
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

## CloudFront
variable "cf_acm_certificate_arn" {}

variable "cf_aliases" {
  type = "list"
}

variable "cf_enabled" {
  default = "true"
}

variable "cf_compress" {
  default = "false"
}

variable "cf_min_ttl" {
  default = "0"
}

variable "cf_default_ttl" {
  default = "86400"
}

variable "cf_max_ttl" {
  default = "31536000"
}

variable "cf_price_class" {
  default = "PriceClass_All"
}

variable "cf_404_min_ttl" {
  default = "60"
}

variable "cf_500_min_ttl" {
  default = "0"
}

variable "cf_501_min_ttl" {
  default = "0"
}

variable "cf_502_min_ttl" {
  default = "0"
}

variable "cf_503_min_ttl" {
  default = "0"
}

variable "cf_504_min_ttl" {
  default = "0"
}

variable "cf_ssl_support_method" {
  default = "sni-only"
}

variable "cf_ipv6" {
  type    = "string"
  default = "true"
}

variable "web_acl_id" {
  default = ""
}

## Logs
variable "log_retention" {
  default = 30
}

variable "logs_filter_pattern" {
  default = "?\"[INFO]\" ?\"[WARNING]\" ?\"[ERROR]\""
}

variable "enable_s3_logs" {
  default = false
}

variable "enable_es_logs" {
  default = false
}

variable "es_logs_domain" {
  default = ""
}

variable "es_logs_index_name" {
  default = ""
}

variable "es_logs_type_name" {
  default = ""
}
