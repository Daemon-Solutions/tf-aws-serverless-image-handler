output "cf_domain_name" {
  value = "${aws_cloudfront_distribution.distribution.domain_name}"
}

output "image_handler_bucket" {
  value = "${aws_s3_bucket.bucket.id}"
}
