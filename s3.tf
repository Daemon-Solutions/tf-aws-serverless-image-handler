resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${random_id.id.hex}"
  policy = "${data.aws_iam_policy_document.cloudfront.json}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambdas/image-handler"
  output_path = "${path.module}/files/serverless-image-handler.zip"
}

resource "aws_s3_bucket_object" "lambda" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "serverless-image-handler.zip"
  source = "${path.module}/files/serverless-image-handler.zip"
  etag   = "${md5(file("${data.archive_file.lambda.output_path}"))}"
}
