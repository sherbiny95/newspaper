resource "aws_api_gateway_rest_api" "news_api" {
  name = "newspaper"
  #   disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_rest_api.news_api.root_resource_id
  path_part   = "news"
}

resource "aws_api_gateway_method" "get_news" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.news.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "news_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.get_news.http_method

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_news.lambda_function_invoke_arn
}

resource "aws_api_gateway_resource" "newsitem" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_resource.news.id
  path_part   = "newsitem"
}

resource "aws_api_gateway_method" "post_newsitem" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.newsitem.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "new_itemlambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.post_newsitem.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_news.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "news_deployment" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.news,
      aws_api_gateway_method.get_news,
      aws_api_gateway_resource.newsitem,
      aws_api_gateway_method.post_newsitem,
      aws_api_gateway_rest_api.news_api
    ]))
  }
  stage_name = var.stage_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.news_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  stage_name    = var.stage_name
}