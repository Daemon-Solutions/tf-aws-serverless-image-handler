# Image Lambda IAM role
resource "aws_iam_role" "lambda" {
  name               = "${var.name}-lambda-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}-${random_id.id.hex}:*"]
  }
}

data "aws_iam_policy_document" "rekognition" {
  statement {
    effect = "Allow"

    actions = [
      "rekognition:DetectFaces",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.origin_bucket}/*",
      "arn:aws:s3:::${var.origin_bucket}",
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${var.name}-logs-${random_id.id.hex}"
  policy = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_iam_policy_attachment" "logs" {
  name       = "${var.name}-logs-${random_id.id.hex}"
  roles      = ["${aws_iam_role.lambda.name}"]
  policy_arn = "${aws_iam_policy.logs.arn}"
}

resource "aws_iam_policy" "rekognition" {
  name   = "${var.name}-rekognition-${random_id.id.hex}"
  policy = "${data.aws_iam_policy_document.rekognition.json}"
}

resource "aws_iam_policy_attachment" "rekognition" {
  name       = "${var.name}-rekognition-${random_id.id.hex}"
  roles      = ["${aws_iam_role.lambda.name}"]
  policy_arn = "${aws_iam_policy.rekognition.arn}"
}

resource "aws_iam_policy" "s3" {
  name   = "${var.name}-s3-${random_id.id.hex}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

resource "aws_iam_policy_attachment" "s3" {
  name       = "${var.name}-s3-${random_id.id.hex}"
  roles      = ["${aws_iam_role.lambda.name}"]
  policy_arn = "${aws_iam_policy.s3.arn}"
}

# Log proccessor Lambda role
resource "aws_iam_role" "log_processor" {
  name               = "${var.name}-log-processor-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "log_processor" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}-log-processor-${random_id.id.hex}:*"]
  }
}

resource "aws_iam_role_policy" "log_processor" {
  name   = "${var.name}-log-processor-${random_id.id.hex}"
  role   = "${aws_iam_role.log_processor.name}"
  policy = "${data.aws_iam_policy_document.log_processor.json}"
}

# CloudWatch Logs IAM role
resource "aws_iam_role" "cwlogs" {
  name               = "${var.name}-cwlogs-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.cwlogs_assume_role.json}"
}

data "aws_iam_policy_document" "cwlogs_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "cwlogs_firehose" {
  statement {
    effect = "Allow"

    actions = [
      "firehose:*",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.stream.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "cwlogs_firehose" {
  name   = "${var.name}-cwlogs-firehose-${random_id.id.hex}"
  role   = "${aws_iam_role.cwlogs.name}"
  policy = "${data.aws_iam_policy_document.cwlogs_firehose.json}"
}

# Firehose IAM role
resource "aws_iam_role" "firehose" {
  name               = "${var.name}-firehose-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.firehose_assume_role.json}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "firehose.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "firehose_log_processor" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "${aws_lambda_function.log_processor.arn}",
      "${aws_lambda_function.log_processor.arn}:*",
    ]
  }
}

data "aws_iam_policy_document" "firehose_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.bucket.id}",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_processor" {
  name   = "${var.name}-firehose-log-processor-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_log_processor.json}"
}

resource "aws_iam_role_policy" "firehose_s3" {
  name   = "${var.name}-firehose-s3-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_s3.json}"
}

# Allow CloudFront access to bucket for logging
data "aws_iam_policy_document" "cloudfront" {
  statement {
    sid = "AWSCloudFrontLogging"

    actions = [
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = [
      "arn:aws:s3:::${var.name}-${random_id.id.hex}",
    ]
  }
}
