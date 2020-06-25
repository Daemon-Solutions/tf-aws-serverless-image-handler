provider "aws" {
  region = "us-east-1"
  alias  = "us"
}

data "aws_route53_zone" "media" {
  name = "trynotto.click."
}

resource "aws_route53_record" "media" {
  zone_id = data.aws_route53_zone.media.zone_id
  name    = "media.${data.aws_route53_zone.media.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.serverless_image_handler.cf_domain_name]
}

resource "aws_acm_certificate" "media" {
  provider          = aws.us
  domain_name       = "media.${data.aws_route53_zone.media.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "media_cert_validation" {
  name    = aws_acm_certificate.media.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.media.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.media.id
  records = [aws_acm_certificate.media.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "media" {
  provider                = aws.us
  certificate_arn         = aws_acm_certificate.media.arn
  validation_record_fqdns = [aws_route53_record.media_cert_validation.fqdn]
}
