provider "aws" {

}

terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "newspaper-state-${get_aws_account_id()}"
    key            = "terraform.tfstate"
  }
}