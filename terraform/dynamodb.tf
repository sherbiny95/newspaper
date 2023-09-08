resource "aws_dynamodb_table" "newspaper_articles" {
  name         = "newspaper-articles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Title"
  attribute {
    name = "Title"
    type = "S"
  }
  attribute {
    name = "Date"
    type = "S"
  }
  attribute {
    name = "Description"
    type = "S"
  }
}
