locals {
  namespace = var.namespace

  vpc = {
    name                 = "main"
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
  }

  subnet = {
    name                    = "public-a"
    availability_zone       = "ap-northeast-2a"
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
  }
}