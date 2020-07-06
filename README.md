# tf-aws-serverless-image-handler

This module provides a CloudFront distribution for image manipulation, such as resizing, quality reduction or feature detection and sources the images from an s3 bucket you provide.

CloudFront logs are stored in a provided s3 bucket.

This solution was adapted from https://github.com/awslabs/serverless-image-handler

### Request path

CloudFront -> API Gateway -> Lambda -> s3

## Supported Filters

Note: These are Thumbor filters and may not work correctly with the current SharpJS version. See https://sharp.pixelplumbing.com/

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

A simple usage example:

```
module "serverless_image_handler" {
  source = "../"

  origin_bucket = aws_s3_bucket.media.id
  log_bucket    = aws_s3_bucket.logs.id

  cf_aliases             = ["media.trynotto.click"]
  cf_acm_certificate_arn = aws_acm_certificate.media.arn
}
```

An image called `face.jpg` resized to `200x200` can then be accessed via the URL:

`https://media.trynotto.click/fit-in/200x200/face.jpg`

More advanced options can be configured with additional variables. See below.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_webp | Automatically return Webp format images based on the client Accept header. | `string` | `"False"` | no |
| cf\_404\_min\_ttl | Minumum TTL of 404 responses. | `string` | `"60"` | no |
| cf\_500\_min\_ttl | Minumum TTL of 500 responses. | `string` | `"0"` | no |
| cf\_501\_min\_ttl | Minumum TTL of 501 responses. | `string` | `"0"` | no |
| cf\_502\_min\_ttl | Minumum TTL of 502 responses. | `string` | `"0"` | no |
| cf\_503\_min\_ttl | Minumum TTL of 503 responses. | `string` | `"0"` | no |
| cf\_504\_min\_ttl | Minumum TTL of 504 responses. | `string` | `"0"` | no |
| cf\_acm\_certificate\_arn | ACM certificate to use with the created CloudFront distribution. | `any` | n/a | yes |
| cf\_aliases | Aliases for the CloudFront distribution. | `list(string)` | n/a | yes |
| cf\_compress | Enable automatic response compression. | `string` | `"false"` | no |
| cf\_default\_ttl | Default TTL in seconds. | `string` | `"86400"` | no |
| cf\_enabled | State of the CloudFront distribution. | `string` | `"true"` | no |
| cf\_ipv6 | Enable IPv6 on the CloudFront distribution. | `string` | `"true"` | no |
| cf\_log\_prefix | CloudFront log prefix. | `string` | `"cloudfront/"` | no |
| cf\_max\_ttl | Maximum TTL in seconds. | `string` | `"31536000"` | no |
| cf\_min\_ttl | Minimum TTL in seconds. | `string` | `"0"` | no |
| cf\_ordered\_cache\_behavior | Additional cache behaviors for the created CloudFront distribution. | <pre>list(object({<br>    path_pattern                      = string<br>    allowed_methods                   = list(string)<br>    cached_methods                    = list(string)<br>    compress                          = string<br>    target_origin_id                  = string<br>    forward_query_string              = string<br>    forward_query_string_cache_keys   = list(string)<br>    forward_cookies                   = string<br>    forward_cookies_whitelisted_names = list(string)<br>    forward_headers                   = list(string)<br>    viewer_protocol_policy            = string<br>    min_ttl                           = number<br>    default_ttl                       = number<br>    max_ttl                           = number<br>    trusted_signers                   = list(string)<br>    smooth_streaming                  = string<br>    field_level_encryption_id         = string<br>  }))</pre> | `[]` | no |
| cf\_price\_class | Price class of the CloudFront distribution. | `string` | `"PriceClass_All"` | no |
| cf\_s3\_origin | Additional s3 origins for the created CloudFront distribution. | <pre>list(object({<br>    domain_name            = string<br>    origin_id              = string<br>    origin_access_identity = string<br>  }))</pre> | `[]` | no |
| cf\_ssl\_support\_method | Method by which CloudFront serves HTTPS requests. | `string` | `"sni-only"` | no |
| cors\_origin | Value returned by the API in the Access-Control-Allow-Origin header. A star (\*) value will support any origin. | `string` | `"*"` | no |
| cw\_log\_prefix | CloudWatch log prefix. | `string` | `"cloudwatch/"` | no |
| enable\_cors | Enable API Cross-Origin Resource Sharing (CORS) support. | `string` | `"No"` | no |
| log\_bucket | Bucket where to store logs. | `any` | n/a | yes |
| log\_retention | Log retention in days. | `number` | `30` | no |
| memory\_size | Memory to assign to the image Lambda function. | `string` | `"1536"` | no |
| name | Custom name for created resources. | `string` | `"tf-aws-serverless-image-handler"` | no |
| origin\_bucket | Bucket where the source images reside. | `any` | n/a | yes |
| random\_byte\_length | The byte length of the random id generator used for unique resource names. | `number` | `4` | no |
| rewrite\_match\_pattern | Regex for matching custom image requests using the rewrite function. | `string` | `""` | no |
| rewrite\_substitution | Substitution string for matching custom image requests using the rewrite function. | `string` | `""` | no |
| safe\_url | Toggle to enable safe URL's. | `string` | `"False"` | no |
| security\_key | Key to use to generate safe URL's. | `string` | `""` | no |
| timeout | Timeout in seconds of the image Lambda function. | `string` | `"20"` | no |
| web\_acl\_id | WAF ACL to use with the CloudFront distribution. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_distribution\_id | Distribution ID of the created CloudFront distribution. |
| cf\_domain\_name | Domain name of the created CloudFront distribution. |
| image\_handler\_bucket | Bucket created to store the Lambda function. |
| image\_handler\_log\_group | CloudWatch log group for the image handler. |
| image\_handler\_log\_group\_arn | CloudWatch log group ARN for the image handler. |
