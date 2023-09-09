resource "aws_cloudfront_distribution" "news" {
  origin {
    domain_name = replace(aws_api_gateway_deployment.news_deployment.invoke_url, "/^https?://([^/]*).*/", "$1")
    origin_id   = "apigw"
    origin_path = "/${var.stage_name}"
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "apigw"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

#   ordered_cache_behavior {
#     path_pattern = "/news"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = "apigw"
#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

  ordered_cache_behavior {
    path_pattern = "/newsitem"
    allowed_methods  = ["POST", "HEAD", "OPTIONS"]
    cached_methods   = ["POST", "HEAD", "OPTIONS"]
    target_origin_id = "apigw"
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