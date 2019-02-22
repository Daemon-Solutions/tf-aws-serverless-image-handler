output "cf_domain_name" {
  description = "Domain name of the created CloudFront distribution."
  value       = "${aws_cloudfront_distribution.distribution.domain_name}"
}

output "image_handler_bucket" {
  description = "Bucket created to store the Lambda function and logs."
  value       = "${aws_s3_bucket.bucket.id}"
}
