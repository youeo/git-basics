resource "aws_vpc" "this" {
  cidr_block           = vpc.cidr_block
  enable_dns_support   = vpc.enable_dns_support
  enable_dns_hostnames = vpc.enable_dns_hostnames

  tags = {
    Name = "${local.namespace}-vpc-${local.vpc.name}"
  }
}