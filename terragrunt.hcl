remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "newspaper-state-${get_aws_account_id()}"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    dynamodb_table  = "newspaper-state-${get_aws_account_id()}-locktable"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.0"
    }
  }
}

EOF
}