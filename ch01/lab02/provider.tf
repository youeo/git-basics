terraform {
  required_version = ">= 1.14.0" #>=버전 : 해당 버전보다 큰 버전이면 사용 가능

  required_providers {
    #azurm
    aws = {
      # provider를 모아놓은 곳(hashicorp : 공식)
      # https://registry.terraform.io/providers/hashicorp/aws/latest
      source  = "hashicorp/aws"
      version = "~>6.0" # ~>버전 : 해당 버전대만 가능, 즉 6.9까지 가능, 7은 불가능
    }
  }
}

provider "aws" {
  region = "ap-northeast-2" # 따로 안적으면 aws 인증했던 region이 기본이 된다.
}

# format 코드 정리 : 전체 드래그 + shift+alt+F