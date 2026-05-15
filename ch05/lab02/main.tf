resource "aws_vpc" "main" {
  cidr_block           = local.network.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.namespace}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.namespace}-igw"
  }
}

resource "aws_security_group" "main" {
  for_each = local.sg_config

  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
	  # local에서 필터링된 값에 의해 각각 설정됨
    for_each = toset([each.value])

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidrs
    }
  }

  dynamic "egress" {
	  # instance-service인 항목만 egress가 만들어짐
    for_each = toset(each.key == "instance-service" ? [1] : [])

    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "${local.namespace}-sg-${each.key}"
  }
}