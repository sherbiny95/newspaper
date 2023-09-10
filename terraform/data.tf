data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "news_lambda" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.newspaper_articles.id}"
    ]
  }
}

data "aws_iam_policy_document" "api_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3_react_app" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_react_app.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.news.arn]
      variable = "AWS:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "api" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["execute-api:Invoke"]
    resources = [aws_api_gateway_rest_api.news_api.execution_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.module.s3_react_app.s3_bucket_arn]
    }
  }
}
