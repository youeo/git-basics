# resource "aws_subnet" "this" {
#   vpc_id                  = "vpc-0abc1234567890def"
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "ap-northeast-2a"
#   map_public_ip_on_launch = true
# }
resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.namespace}-subnet-${var.name}"
  }
}
