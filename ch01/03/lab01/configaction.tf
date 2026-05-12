terraform {
  required_version = ">=1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

locals {
  vpc_cidr_block = "10.0.0.0/24"
}


resource "aws_vpc" "main" {
											# locals에 적힌 내용은 local로 표현
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    # Naming 규칙 : organization project resource capability(용도)
    Name = "tf-user-lab02-vpc-main"
  }
}

resource "aws_security_group" "web1" {
  name = "tf-core-lab01-sg-web1"

  tags = {
    Name = "tf-core-lab01-sg-web1"
  }
}
resource "aws_security_group" "web2" {
  name = "tf-core-lab01-sg-web2"

  tags = {
    Name = "tf-core-lab01-sg-web2"
  }
}

output "sg" {
  value = aws_security_group.web1.id
}

output "sg2" {
  value = aws_security_group.web2.id
}