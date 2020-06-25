resource "aws_cloudwatch_log_group" "image" {
  name              = "/aws/lambda/${var.name}-${random_id.id.hex}"
  retention_in_days = var.log_retention
}
