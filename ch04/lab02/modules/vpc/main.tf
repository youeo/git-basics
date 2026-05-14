# resource "aws_vpc" "this" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
# }
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.namespace}-vpc-${var.name}"
  }
}