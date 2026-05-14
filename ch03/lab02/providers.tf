terraform {
  required_version = ">=1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # 마이그레이션 이전에는 이 부분을 주석처리한 후 진행
  # 리소스들이 생성됐다면 주석을 풀고 t init -migrate-state로 마이그레이션 진행
  # 마이그레이션은 S3가 있다는 전제가 되어야해서 생성과 동시에 이전은 안됨
  backend "s3" {
    bucket       = "tf-core-ej-tfstate"
    key          = "gallery/terraform.tfstate"
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
      ManagedBy    = "Terraform"
    }
  }
}