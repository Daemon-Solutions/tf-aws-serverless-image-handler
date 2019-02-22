# tf-aws-serverless-image-handler
WIP

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
| es\_logs\_index\_name |  | string | `""` | no |
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
| cf\_domain\_name |  |
| image\_handler\_bucket |  |
