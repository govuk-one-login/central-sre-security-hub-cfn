terraform {
  required_version = ">= 1.7.3"
  
  backend "s3" {
    bucket = "di-central-sre-build-tfstate"
    key    = "service_catalog_product_tests/pipeline_dependencies.tfstate"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  allowed_account_ids = ["891376909120"]
  region              = "eu-west-2"
}