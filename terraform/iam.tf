resource "aws_iam_role" "api_cloudwatch" {
  name               = "api_gateway_cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.api_assume_role.json
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.api_cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}