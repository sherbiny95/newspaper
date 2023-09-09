data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "news_lambda" {
  statement {
    actions = [
      "dynamodb:Scan",
      "dynamodb:GetItem"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.newspaper_articles.id}"
    ]
  }
}