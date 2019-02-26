output "cf_domain_name" {
  description = "Domain name of the created CloudFront distribution."
  value       = "${aws_cloudfront_distribution.distribution.domain_name}"
}

output "image_handler_bucket" {
  description = "Bucket created to store the Lambda function."
  value       = "${aws_s3_bucket.bucket.id}"
}

output "image_handler_log_group" {
  description = "CloudWatch log group for the image handler."
  value       = "${aws_cloudwatch_log_group.image.name}"
}

output "log_processor_log_group" {
  description = "CloudWatch log group for the log processor."
  value       = "${aws_cloudwatch_log_group.log_processor.*.name}"
}
