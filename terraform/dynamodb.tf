resource "aws_dynamodb_table" "newspaper_articles" {
  #  AWS DynamoDB tables are automatically encrypted at rest with an AWS-owned Customer Master Key if this argument isn't specified
  name         = "newspaper-articles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Title"
  attribute {
    name = "Title"
    type = "S"
  }
}
