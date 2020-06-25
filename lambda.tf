module "lambda" {
  source  = "raymondbutcher/lambda-builder/aws"
  version = "1.0.2"

  function_name = "${var.name}-${random_id.id.hex}"
  description   = "Serverless Image Handler: This function is invoked by the serverless-image-handler API Gateway to manipulate images with SharpJS."
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  s3_bucket     = aws_s3_bucket.bucket.id
  create_role   = false
  role          = aws_iam_role.lambda.arn
  timeout       = var.timeout
  memory_size   = var.memory_size

  build_mode = "LAMBDA"
  source_dir = "${path.module}/src"

  environment = {
    variables = {
      AUTO_WEBP             = var.auto_webp
      CORS_ORIGIN           = var.cors_origin
      ENABLE_CORS           = var.enable_cors
      REWRITE_MATCH_PATTERN = var.rewrite_match_pattern
      REWRITE_SUBSTITUTION  = var.rewrite_substitution
      SAFE_URL              = var.safe_url
      SECURITY_KEY          = var.security_key
      SOURCE_BUCKETS        = var.origin_bucket
    }
  }
}
