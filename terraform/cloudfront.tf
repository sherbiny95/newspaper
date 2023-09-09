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
  enabled         = true
  price_class         = "PriceClass_100"


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = module.s3_react_app.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false  # Do not forward query strings
      cookies {
        forward = "none"   # Do not forward cookies
      }
      headers = ["Origin"]
    }
  }

  ordered_cache_behavior {
    path_pattern = "/newsitem"
    allowed_methods  = ["POST", "HEAD", "OPTIONS"]
    cached_methods   = ["POST", "HEAD", "OPTIONS"]
    target_origin_id = module.s3_react_app.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      locations = [
        "NL"
      ]
      restriction_type = "whitelist"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}