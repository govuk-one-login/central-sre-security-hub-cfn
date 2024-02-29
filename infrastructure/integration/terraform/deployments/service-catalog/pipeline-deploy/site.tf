terraform {
  required_version = ">= 1.7.3"

  backend "s3" {
    bucket = "devplatform-service-catalog-tfstate"
    key    = "integration/service_catalog/pipeline_deploy.tfstate"
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
  allowed_account_ids = ["637423182621"]
  region              = "eu-west-2"
}