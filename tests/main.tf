module "serverless_image_handler" {
  source = "../"

  origin_bucket = "${aws_s3_bucket.media.id}"

  aliases             = ["media.trynotto.click"]
  acm_certificate_arn = "${aws_acm_certificate.media.arn}"
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
