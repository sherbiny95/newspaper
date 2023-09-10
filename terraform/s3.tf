module "s3_react_app" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket              = "newspaper-app-${data.aws_caller_identity.current.account_id}"
  block_public_acls   = true
  block_public_policy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
  
  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "POST"]
      allowed_origins = ["https://${module.s3_react_app.s3_bucket_bucket_regional_domain_name}"]
      expose_headers  = []
      max_age_seconds = 3600
    }
  ]
  attach_policy = false
}

resource "aws_s3_bucket_policy" "react_app" {
  bucket = module.s3_react_app.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_react_app.json
}