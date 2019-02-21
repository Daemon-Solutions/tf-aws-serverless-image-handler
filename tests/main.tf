module "serverless_image_handler" {
  source = "../"

  origin_bucket = "${aws_s3_bucket.media.id}"

  cf_aliases             = ["media.trynotto.click"]
  cf_acm_certificate_arn = "${aws_acm_certificate.media.arn}"

  enable_s3_logs = true
}

resource "aws_s3_bucket" "media" {
  bucket = "tf-aws-serverless-image-handler-media"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
