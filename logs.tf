resource "aws_cloudwatch_log_group" "image" {
  name              = "/aws/lambda/${var.name}-${random_id.id.hex}"
  retention_in_days = "${var.log_retention}"
}

resource "aws_cloudwatch_log_group" "log_processor" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name              = "/aws/lambda/${var.name}-log-processor-${random_id.id.hex}"
  retention_in_days = "${var.log_retention}"
}

resource "aws_cloudwatch_log_subscription_filter" "s3_logs" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  depends_on = [
    "aws_cloudwatch_log_group.image",
  ]

  name            = "${var.name}-${random_id.id.hex}"
  role_arn        = "${aws_iam_role.cwlogs.arn}"
  log_group_name  = "/aws/lambda/${var.name}-${random_id.id.hex}"
  filter_pattern  = "${var.logs_filter_pattern}"
  destination_arn = "${aws_kinesis_firehose_delivery_stream.s3_stream.arn}"
  distribution    = "Random"
}

resource "aws_cloudwatch_log_subscription_filter" "es_logs" {
  count = "${var.enable_es_logs ? 1 : 0}"

  depends_on = [
    "aws_cloudwatch_log_group.image",
  ]

  name            = "${var.name}-${random_id.id.hex}"
  role_arn        = "${aws_iam_role.cwlogs.arn}"
  log_group_name  = "/aws/lambda/${var.name}-${random_id.id.hex}"
  filter_pattern  = "${var.logs_filter_pattern}"
  destination_arn = "${aws_kinesis_firehose_delivery_stream.es_stream.arn}"
  distribution    = "Random"
}

resource "aws_kinesis_firehose_delivery_stream" "s3_stream" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  name        = "${var.name}-s3-${random_id.id.hex}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.firehose.arn}"
    bucket_arn = "arn:aws:s3:::${var.log_bucket}"
    prefix     = "${var.cw_log_prefix}"

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

resource "aws_kinesis_firehose_delivery_stream" "es_stream" {
  count = "${var.enable_es_logs ? 1 : 0}"

  name        = "${var.name}-es-${random_id.id.hex}"
  destination = "elasticsearch"

  s3_configuration {
    role_arn   = "${aws_iam_role.firehose.arn}"
    bucket_arn = "arn:aws:s3:::${var.log_bucket}"
    prefix     = "${var.cw_log_prefix}"
  }

  elasticsearch_configuration {
    domain_arn = "${var.es_logs_domain}"
    role_arn   = "${aws_iam_role.firehose.arn}"
    index_name = "${var.es_logs_index_name}"
    type_name  = "${var.es_logs_type_name}"

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
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  type        = "zip"
  source_file = "${path.module}/lambdas/log-processor/lambda.py"
  output_path = "${path.module}/files/log-processor.zip"
}

resource "aws_lambda_function" "log_processor" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  filename         = "${path.module}/files/log-processor.zip"
  source_code_hash = "${base64sha256(file("${data.archive_file.log_processor.output_path}"))}"
  function_name    = "${var.name}-log-processor-${random_id.id.hex}"
  description      = "An Amazon Kinesis Firehose stream processor that extracts individual log events from records sent by Cloudwatch Logs subscription filters."
  role             = "${aws_iam_role.log_processor.arn}"
  handler          = "lambda.handler"
  runtime          = "python2.7"
  timeout          = "60"
}
