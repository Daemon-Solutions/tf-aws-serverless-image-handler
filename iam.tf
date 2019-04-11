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

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.cache.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "logs" {
  name   = "${var.name}-logs-${random_id.id.hex}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_iam_role_policy" "rekognition" {
  name   = "${var.name}-rekognition-${random_id.id.hex}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${data.aws_iam_policy_document.rekognition.json}"
}

resource "aws_iam_role_policy" "s3" {
  name   = "${var.name}-s3-${random_id.id.hex}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

# Log proccessor Lambda role
resource "aws_iam_role" "log_processor" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name               = "${var.name}-log-processor-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "log_processor" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

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
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-log-processor-${random_id.id.hex}"
  role   = "${aws_iam_role.log_processor.name}"
  policy = "${data.aws_iam_policy_document.log_processor.json}"
}

# CloudWatch Logs IAM role
resource "aws_iam_role" "cwlogs" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name               = "${var.name}-cwlogs-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.cwlogs_assume_role.json}"
}

data "aws_iam_policy_document" "cwlogs_assume_role" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

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

data "aws_iam_policy_document" "cwlogs_s3_firehose" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "firehose:*",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.s3_stream.arn}",
    ]
  }
}

data "aws_iam_policy_document" "cwlogs_es_firehose" {
  count = "${var.enable_es_logs ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "firehose:*",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.es_stream.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "cwlogs_s3_firehose" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  name   = "${var.name}-cwlogs-s3-firehose-${random_id.id.hex}"
  role   = "${aws_iam_role.cwlogs.name}"
  policy = "${data.aws_iam_policy_document.cwlogs_s3_firehose.json}"
}

resource "aws_iam_role_policy" "cwlogs_es_firehose" {
  count = "${var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-cwlogs-es-firehose-${random_id.id.hex}"
  role   = "${aws_iam_role.cwlogs.name}"
  policy = "${data.aws_iam_policy_document.cwlogs_es_firehose.json}"
}

# Firehose IAM role
resource "aws_iam_role" "firehose" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name               = "${var.name}-firehose-${random_id.id.hex}"
  assume_role_policy = "${data.aws_iam_policy_document.firehose_assume_role.json}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

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
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

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

data "aws_iam_policy_document" "firehose_kinesis_s3" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.s3_stream.arn}",
    ]
  }
}

data "aws_iam_policy_document" "firehose_kinesis_es" {
  count = "${var.enable_es_logs ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
    ]

    resources = [
      "${aws_kinesis_firehose_delivery_stream.es_stream.arn}",
    ]
  }
}

data "aws_iam_policy_document" "firehose_s3" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

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
      "arn:aws:s3:::${var.log_bucket}/*",
      "arn:aws:s3:::${var.log_bucket}",
    ]
  }
}

data "aws_iam_policy_document" "firehose_es" {
  count = "${var.enable_es_logs ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "es:DescribeElasticsearchDomain",
      "es:DescribeElasticsearchDomains",
      "es:DescribeElasticsearchDomainConfig",
      "es:ESHttpPost",
      "es:ESHttpPut",
    ]

    resources = [
      "${var.es_logs_domain}",
      "${var.es_logs_domain}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "es:ESHttpGet",
    ]

    resources = [
      "${var.es_logs_domain}/_all/_settings",
      "${var.es_logs_domain}/_cluster/stats",
      "${var.es_logs_domain}/${var.es_logs_index_name}*/_mapping/${var.es_logs_type_name}",
      "${var.es_logs_domain}/_nodes",
      "${var.es_logs_domain}/_nodes/stats",
      "${var.es_logs_domain}/_nodes/*/stats",
      "${var.es_logs_domain}/_stats",
      "${var.es_logs_domain}/${var.es_logs_index_name}*/_stats",
    ]
  }
}

resource "aws_iam_role_policy" "firehose_log_processor" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-firehose-log-processor-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_log_processor.json}"
}

resource "aws_iam_role_policy" "firehose_kinesis_s3" {
  count = "${var.enable_s3_logs ? 1 : 0}"

  name   = "${var.name}-firehose-kinesis-s3-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_kinesis_s3.json}"
}

resource "aws_iam_role_policy" "firehose_kinesis_es" {
  count = "${var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-firehose-kinesis-es-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_kinesis_es.json}"
}

resource "aws_iam_role_policy" "firehose_s3" {
  count = "${var.enable_s3_logs || var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-firehose-s3-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_s3.json}"
}

resource "aws_iam_role_policy" "firehose_es" {
  count = "${var.enable_es_logs ? 1 : 0}"

  name   = "${var.name}-firehose-es-${random_id.id.hex}"
  role   = "${aws_iam_role.firehose.name}"
  policy = "${data.aws_iam_policy_document.firehose_es.json}"
}
