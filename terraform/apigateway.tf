resource "aws_api_gateway_rest_api" "news_api" {
  name = "newspaper"
  #   disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# resource "aws_api_gateway_rest_api_policy" "news_api" {
#   rest_api_id = aws_api_gateway_rest_api.news_api.id
#   policy      = data.aws_iam_policy_document.api.json
# }

#############
# GET /news #
#############

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

resource "aws_api_gateway_method_response" "get_news_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.get_news.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "news_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.get_news.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_news.lambda_function_invoke_arn
}

resource "aws_api_gateway_integration_response" "news_lambda_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.get_news.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.news.domain_name}'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, HEAD, OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  #     "method.response.header.Access-Control-Allow-Methods" = "'*'",
  #     "method.response.header.Access-Control-Allow-Headers" = "'*'"
  #   }
}

# CORS

resource "aws_api_gateway_method" "news_cors_options" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.news.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "news_cors_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.news_cors_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "news_cors_integration" {
  rest_api_id     = aws_api_gateway_rest_api.news_api.id
  resource_id     = aws_api_gateway_resource.news.id
  http_method     = aws_api_gateway_method.news_cors_options.http_method
  type            = "MOCK"
  connection_type = "INTERNET"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}

resource "aws_api_gateway_integration_response" "news_cors_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.news.id
  http_method = aws_api_gateway_method.news_cors_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.news.domain_name}'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, HEAD, OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  #     "method.response.header.Access-Control-Allow-Methods" = "'*'",
  #     "method.response.header.Access-Control-Allow-Headers" = "'*'"
  #   }
}

##################
# POST /newsitem #
##################

resource "aws_api_gateway_resource" "newsitem" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_rest_api.news_api.root_resource_id
  path_part   = "newsitem"
}

resource "aws_api_gateway_method" "post_newsitem" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.newsitem.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_newsitem_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.post_newsitem.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "news_item_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.post_newsitem.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_news.lambda_function_invoke_arn
}

resource "aws_api_gateway_integration_response" "news_item__lambda_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.post_newsitem.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.news.domain_name}'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, HEAD, OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  #     "method.response.header.Access-Control-Allow-Methods" = "'*'",
  #     "method.response.header.Access-Control-Allow-Headers" = "'*'"
  #   }
}

# CORS

resource "aws_api_gateway_method" "newsitem_cors_options" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.newsitem.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "newsitem_cors_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.newsitem_cors_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "newsitem_cors_integration" {
  rest_api_id     = aws_api_gateway_rest_api.news_api.id
  resource_id     = aws_api_gateway_resource.newsitem.id
  http_method     = aws_api_gateway_method.newsitem_cors_options.http_method
  type            = "MOCK"
  connection_type = "INTERNET"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}

resource "aws_api_gateway_integration_response" "newsitem_cors_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.newsitem.id
  http_method = aws_api_gateway_method.newsitem_cors_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.news.domain_name}'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, POST, DELETE, HEAD, OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  #     "method.response.header.Access-Control-Allow-Methods" = "'*'",
  #     "method.response.header.Access-Control-Allow-Headers" = "'*'"
  #   }
}


########################
# Deployment and Stage #
########################

resource "aws_api_gateway_deployment" "news_deployment" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.news,
      aws_api_gateway_method.get_news,
      aws_api_gateway_integration.news_lambda_integration,
      aws_api_gateway_resource.newsitem,
      aws_api_gateway_method.post_newsitem,
      aws_api_gateway_integration.news_item_lambda_integration,
      aws_api_gateway_method.news_cors_options,
      aws_api_gateway_integration.news_cors_integration,
      aws_api_gateway_method.newsitem_cors_options,
      aws_api_gateway_integration.newsitem_cors_integration,
    ]))
  }
  depends_on = [
    aws_api_gateway_method.get_news,
    aws_api_gateway_integration.news_lambda_integration
  ]
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

###########
# Logging #
###########

resource "aws_api_gateway_account" "logging" {
  cloudwatch_role_arn = aws_iam_role.api_cloudwatch.arn
}
