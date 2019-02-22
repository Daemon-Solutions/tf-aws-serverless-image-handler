# tf-aws-serverless-image-handler

This module provides a CloudFront distribution for image manipulation, such as resizing, quality reduction or feature detection and sources the images from an s3 bucket you provide.

CloudFront logs are stored in s3, and optionally the Lambda function logs can be sent to s3 or Elasticsearch.

This solution was adapted from https://github.com/awslabs/serverless-image-handler

### Request path

CloudFront -> API Gateway -> Lambda -> s3

## Supported Filters

| Filter Name |  Filter Syntax |
|-------------|----------------|
| Background color |  /filters:background_color(color)/ |
| Blur |  /filters:blur(7)/ |
| Brightness |  /filters:brightness(40)/ |
| Color fill |  /filters:fill(color)/ |
| Contrast |  /filters:contrast(40)/ |
| Convolution |  /filters:convolution(1;2;1;2;4;2;1;2;1,3,false)/ |
| Equalize |  /filters:equalize()/ |
| Format |  /filters:format(jpeg)/ |
| Grayscale |  /filters:grayscale()/ |
| Image type (jpeg,png,webp,gif) |  /filters:format(jpeg)/ |
| Max bytes |  /filters:max_bytes(40000)/ |
| Noise |  /filters:noise(40)/ |
| Quality |  /filters:quality(40)/ |
| Resize |  /fit-in/800x1000/ |
| RGB |  /filters:rgb(20,-20,40)/ |
| Rotate |  /filters:rotate(90)/ |
| Round Corner |  /filters:round_corner(20,255,255,255)/ |
| Strip ICC |  /filters:strip_icc(10)/ |
| Watermark |  /filters:watermark(https://) |
| SmartCrop |  /smart |

## Usage

A simple usage:

```
module "serverless_image_handler" {
  source = "../"

  origin_bucket = "${aws_s3_bucket.media.id}"

  cf_aliases             = ["media.trynotto.click"]
  cf_acm_certificate_arn = "${aws_acm_certificate.media.arn}"

  enable_s3_logs = true
}
```
More advanced options can be configured with additional variables. See below.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow\_unsafe\_url | Allow unencrypted URL's. | string | `"True"` | no |
| auto\_webp | Automatically return Webp format images based on the client Accept header. | string | `"False"` | no |
| aws\_endpoint | AWS s3 endpoint per region. | map | `<map>` | no |
| cf\_404\_min\_ttl | Minumum TTL of 404 responses. | string | `"60"` | no |
| cf\_500\_min\_ttl | Minumum TTL of 500 responses. | string | `"0"` | no |
| cf\_501\_min\_ttl | Minumum TTL of 501 responses. | string | `"0"` | no |
| cf\_502\_min\_ttl | Minumum TTL of 502 responses. | string | `"0"` | no |
| cf\_503\_min\_ttl | Minumum TTL of 503 responses. | string | `"0"` | no |
| cf\_504\_min\_ttl | Minumum TTL of 504 responses. | string | `"0"` | no |
| cf\_acm\_certificate\_arn | ACM certificate to use with the created CloudFront distribution. | string | n/a | yes |
| cf\_aliases | Aliases for the CloudFront distribution. | list | n/a | yes |
| cf\_compress | Enable automatic response compression. | string | `"false"` | no |
| cf\_default\_ttl | Default TTL in seconds. | string | `"86400"` | no |
| cf\_enabled | State of the CloudFront distribution. | string | `"true"` | no |
| cf\_ipv6 | Enable IPv6 on the CloudFront distribution. | string | `"true"` | no |
| cf\_max\_ttl | Maximum TTL in seconds. | string | `"31536000"` | no |
| cf\_min\_ttl | Minimum TTL in seconds. | string | `"0"` | no |
| cf\_price\_class | Price class of the CloudFront distribution. | string | `"PriceClass_All"` | no |
| cf\_ssl\_support\_method | Method by which CloudFront serves HTTPS requests. | string | `"sni-only"` | no |
| cors\_origin | Value returned by the API in the Access-Control-Allow-Origin header. A star (*) value will support any origin. | string | `"*"` | no |
| enable\_cors | Enable API Cross-Origin Resource Sharing (CORS) support. | string | `"No"` | no |
| enable\_es\_logs | Enable sending Lambda logs to Elasticsearch via Firehose. | string | `"false"` | no |
| enable\_s3\_logs | Enable sending Lambda CloudWatch logs to s3 via Firehose. | string | `"false"` | no |
| es\_logs\_domain | Elasticsearch domain ARN to send CloudWatch logs to. | string | `""` | no |
| es\_logs\_index\_name | Elasticsearch index name for CloudWatch logs. | string | `""` | no |
| es\_logs\_type\_name | Name of the log type sent to Elasticsearch from CloudWatch logs. | string | `""` | no |
| log\_level | Lambda image handler log level. | string | `"INFO"` | no |
| log\_retention | Log retention in days. | string | `"30"` | no |
| logs\_filter\_pattern | Metric filter to filter logs sent from CloudWatch to s3 or Elasticsearch. | string | `"?\"[INFO]\" ?\"[WARNING]\" ?\"[ERROR]\""` | no |
| name | Custom name for created resources. | string | `"tf-aws-serverless-image-handler"` | no |
| origin\_bucket | Bucket where the source images reside. | string | n/a | yes |
| preserve\_exif\_info | Preserves exif information in generated images. Increases image size. | string | `"False"` | no |
| random\_byte\_length | The byte length of the random id generator used for unique resource names. | string | `"4"` | no |
| security\_key | Key to use to generate safe URL's. | string | `""` | no |
| send\_anonymous\_data | Send anonymous usage data to Amazon. | string | `"No"` | no |
| web\_acl\_id | WAF ACL to use with the CloudFront distribution. | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_domain\_name | Domain name of the created CloudFront distribution. |
| image\_handler\_bucket | Bucket created to store the Lambda function and logs. |
