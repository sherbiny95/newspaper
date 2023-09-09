resource "aws_cloudfront_origin_access_control" "news" {
  name                              = "default"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "news" {
  origin {
    domain_name              = module.s3_react_app.s3_bucket_bucket_regional_domain_name
    origin_id                = module.s3_react_app.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.news.id
  }
  enabled     = true
  default_root_object = "index.html"
  price_class = "PriceClass_100"


  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = module.s3_react_app.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  ordered_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    path_pattern           = "/newsitem"
    allowed_methods        = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = module.s3_react_app.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  restrictions {
    geo_restriction {
      locations = [
        "NL",
        "US"
      ]
      restriction_type = "whitelist"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}