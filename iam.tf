# Image Lambda IAM role
resource "aws_iam_role" "lambda" {
  name               = "${var.name}-lambda-${random_id.id.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
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

resource "aws_iam_role_policy" "logs" {
  name   = "${var.name}-logs-${random_id.id.hex}"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy" "rekognition" {
  name   = "${var.name}-rekognition-${random_id.id.hex}"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.rekognition.json
}

resource "aws_iam_role_policy" "s3" {
  name   = "${var.name}-s3-${random_id.id.hex}"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.s3.json
}
