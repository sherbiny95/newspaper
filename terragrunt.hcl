terraform {
  before_hook "before_hook" {
    commands = ["apply", "plan"]
  }

  source = "${path_relative_from_include()}/terraform//${path_relative_to_include()}"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "newspaper-state-${get_aws_account_id()}"
    key     = "newspaper/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
}
EOF
}