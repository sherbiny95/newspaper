data "archive_file" "python_build" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/lambda-news"
  output_path = "${path.module}/scripts/lambda-news.zip"
}

module "lambda_news" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.0"

  function_name  = "news"
  role_name      = "news"
  handler        = "lambda_news.lambda_handler"
  runtime        = "python3.8"
  create_package = false
  store_on_s3    = false
  publish        = true

  environment_variables = {
    DYNAMODB_TABLE = aws_dynamodb_table.newspaper_articles.id
    CLOUDFRONT_DOMAIN = "https://${aws_cloudfront_distribution.news.domain_name}"
  }

  local_existing_package = data.archive_file.python_build.output_path

  attach_network_policy = true
  attach_policy_jsons   = true
  policy_jsons = [
    data.aws_iam_policy_document.news_lambda.json
  ]
  number_of_policy_jsons = 1
}

resource "aws_lambda_permission" "invoke_lambda_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_news.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.news_api.execution_arn}/*/*"
}