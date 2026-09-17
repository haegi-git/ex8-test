terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "bipa17-std11-ex8-state"
    key            = "public-state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "std11-ex8-lock-table"
  }
}

provider "aws" {
  region = "eu-central-1"
}
