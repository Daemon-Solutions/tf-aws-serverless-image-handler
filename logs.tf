resource "aws_cloudwatch_log_group" "image" {
  name              = "/aws/lambda/${var.name}-${random_id.id.hex}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "log_processor" {
  name              = "/aws/lambda/${var.name}-log-processor-${random_id.id.hex}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_subscription_filter" "logs" {
  depends_on = [
    "aws_cloudwatch_log_group.image",
  ]

  name            = "${var.name}-${random_id.id.hex}"
  role_arn        = "${aws_iam_role.cwlogs.arn}"
  log_group_name  = "/aws/lambda/${var.name}-${random_id.id.hex}"
  filter_pattern  = ""
  destination_arn = "${aws_kinesis_firehose_delivery_stream.stream.arn}"
  distribution    = "Random"
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = "${var.name}-${random_id.id.hex}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.firehose.arn}"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
    prefix     = "cloudwatch/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.log_processor.arn}:$LATEST"
        }
      }
    }
  }
}

data "archive_file" "log_processor" {
  type        = "zip"
  source_file = "${path.module}/lambda/log-processor/lambda.py"
  output_path = "${path.module}/files/log-processor.zip"
}

resource "aws_lambda_function" "log_processor" {
  depends_on = [
    "data.archive_file.log_processor",
  ]

  filename         = "${path.module}/files/log-processor.zip"
  source_code_hash = "${base64sha256(file("${path.module}/files/log-processor.zip"))}"
  function_name    = "${var.name}-log-processor-${random_id.id.hex}"
  role             = "${aws_iam_role.log_processor.arn}"
  handler          = "lambda.handler"
  runtime          = "python2.7"
}
