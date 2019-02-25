module "serverless_image_handler" {
  source = "../"

  origin_bucket = "${aws_s3_bucket.media.id}"
  log_bucket    = "${aws_s3_bucket.logs.id}"

  cf_aliases             = ["media.trynotto.click"]
  cf_acm_certificate_arn = "${aws_acm_certificate.media.arn}"

  enable_s3_logs = true

  allow_unsafe_url = "False"
  security_key     = "testing"
}

resource "aws_s3_bucket" "media" {
  bucket = "tf-aws-serverless-image-handler-media-${random_id.id.hex}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "image" {
  bucket = "${aws_s3_bucket.media.id}"
  key    = "face.jpg"
  source = "images/face.jpg"
  etag   = "${md5(file("images/face.jpg"))}"
}

resource "aws_s3_bucket" "logs" {
  bucket = "tf-aws-serverless-image-handler-logs-${random_id.id.hex}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
