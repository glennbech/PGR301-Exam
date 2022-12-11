terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
  backend "s3" {
    bucket = "onlinestore"
    key    = "1043/terraform-in-pipeline.state"
    region = "eu-west-1"
  }
}