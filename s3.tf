resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${random_id.id.hex}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
