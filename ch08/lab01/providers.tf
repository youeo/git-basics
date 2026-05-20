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
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
    # key는 -backend-config으로 주입
    # 같은 이름의 경로가 이미 있으면 그 안에 추가됨 (아예 동일하면 갱신)
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Organization = local.org
      Project      = local.project
      ManagedBy    = "Terraform"
    }
  }
}