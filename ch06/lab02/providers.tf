terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "tf-core-ej-tfstate"
    # 버킷 안에 각 workspace가 생기고 key에 적힌 순서대로 파일이 생성됨
    key          = "07.02/lab02/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Organization = local.org
      Project      = local.project
      Environment  = local.environment
      ManagedBy    = "Terraform"
    }
  }
}