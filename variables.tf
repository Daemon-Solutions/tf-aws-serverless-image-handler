variable "name" {
  default = "tf-aws-serverless-image-handler"
}

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

variable "random_byte_length" {
  description = "The byte length of the random id generator used for unique resource names."
  default     = 4
}

variable "origin_bucket" {}
variable "acm_certificate_arn" {}

variable "aliases" {
  type = "list"
}

variable "enabled" {
  default = "true"
}

variable "compress" {
  default = "false"
}

variable "min_ttl" {
  default = "0"
}

variable "default_ttl" {
  default = "86400"
}

variable "max_ttl" {
  default = "31536000"
}

variable "price_class" {
  default = "PriceClass_All"
}

variable "404minttl" {
  default = "60"
}

variable "500minttl" {
  default = "0"
}

variable "501minttl" {
  default = "0"
}

variable "502minttl" {
  default = "0"
}

variable "503minttl" {
  default = "0"
}

variable "504minttl" {
  default = "0"
}

variable "ssl_support_method" {
  default = "sni-only"
}

variable "ipv6" {
  type    = "string"
  default = "true"
}

variable "web_acl_id" {
  default = ""
}
