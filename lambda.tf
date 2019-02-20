resource "aws_lambda_function" "lambda" {
  depends_on = [
    "aws_s3_bucket_object.lambda",
  ]

  s3_bucket        = "${aws_s3_bucket.bucket.id}"
  s3_key           = "serverless-image-handler.zip"
  source_code_hash = "${base64sha256(file("${path.module}/files/serverless-image-handler.zip"))}"
  function_name    = "${var.name}-${random_id.id.hex}"
  description      = "Serverless Image Handler: This function is invoked by the serverless-image-handler API Gateway to manipulate images with Thumbor."
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "image_handler/lambda_function.lambda_handler"
  runtime          = "python2.7"
  timeout          = "10"
  memory_size      = "1536"

  environment {
    variables = {
      ALLOW_UNSAFE_URL     = "${var.allow_unsafe_url}"
      CORS_ORIGIN          = "${var.cors_origin}"
      ENABLE_CORS          = "${var.enable_cors}"
      LOG_LEVEL            = "${var.log_level}"
      REKOGNITION_REGION   = "${data.aws_region.current.name}"
      SEND_ANONYMOUS_DATA  = "${var.send_anonymous_data}"
      TC_AWS_ENDPOINT      = "${var.aws_endpoint[data.aws_region.current.name]}"
      TC_AWS_LOADER_BUCKET = "${var.origin_bucket}"
      TC_AWS_REGION        = "${data.aws_region.current.name}"
      UUID                 = "${random_uuid.lambda.result}"
    }
  }
}

resource "random_uuid" "lambda" {}
