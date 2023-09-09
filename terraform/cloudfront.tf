resource "aws_cloudfront_distribution" "news" {
  origin {
    domain_name = "${aws_api_gateway_rest_api.news_api.id}.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = "api_gateway_origin"
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    path_pattern = "/news"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "api_gateway_origin"

    forwarded_values {
      query_string = false
      cookies      = { 
        forward = "none" 
        }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/newsitems"
    allowed_methods  = ["POST", "HEAD", "OPTIONS"]
    cached_methods   = ["POST", "HEAD", "OPTIONS"]
    target_origin_id = "api_gateway_origin"

    forwarded_values {
      query_string = false
      cookies      = { 
        forward = "none" 
        }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
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

  # You can configure other settings such as SSL, logging, and error pages here
}