terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "__tf_bucket__"
    key            = "__stack_prefix__-__group__-infra-stack"
    region         = "__tf_bucket_region__"
  }
}
