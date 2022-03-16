terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.1"
    }
  }
}
provider "aws" {
  region     = var.reg_type
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#creating Module for RDS server to push from resources"
module "RDS Server" {
  source  = "../Resources setup"
  version = "1.0.0"
}
