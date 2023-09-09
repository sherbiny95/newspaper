output "cloudfront_domain_name" {
  value = "${aws_api_gateway_rest_api.news_api.id}.${data.aws_region.current.name}.amazonaws.com"
}