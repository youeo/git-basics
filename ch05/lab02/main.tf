#
# Network
#

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

resource "aws_eip" "natgw" {
	# nat가 있는지, subnet이 있는지 확인
  for_each = toset([
    for s in lookup(local.network, "natgw_subnets", []) : s
      if lookup(aws_subnet.main, s, null) != null
  ])

  domain = "vpc"

  tags = {
    Name = "${local.namespace}-eip-natgw-${each.value}"
  }
}

resource "aws_nat_gateway" "main" {
  for_each = toset([
    for s in lookup(local.network, "natgw_subnets", []) : s
      if lookup(aws_subnet.main, s, null) != null
  ])

  allocation_id = aws_eip.natgw[each.value].id
  subnet_id     = aws_subnet.main[each.value].id

  tags = {
    Name = "${local.namespace}-natgw-${each.value}"
  }
}

resource "aws_subnet" "main" {
  for_each = lookup(local.network, "subnets", {})

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.namespace}-subnet-${each.key}"
  }
}

resource "aws_route_table" "main" {
  for_each = lookup(local.network, "subnets", {})

  vpc_id = aws_vpc.main.id

  dynamic "route" {
	  # public 서브넷에만 igw 등록
    for_each = toset(startswith(each.key, "public") ? [1] : [])

    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  }

  dynamic "route" {
	  # private 서브넷이고 ngw가 있는 경우에 등록
    for_each = toset(
      startswith(each.key, "private") &&
      lookup(each.value, "ref_natgw_subnet", null) != null &&
      contains(keys(aws_nat_gateway.main), lookup(each.value, "ref_natgw_subnet", ""))
      ? [1] : []
    )

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[each.value.ref_natgw_subnet].id
    }
  }

  tags = {
    Name = "${local.namespace}-rt-${each.key}"
  }
}

resource "aws_route_table_association" "main" {
	# 서브넷 각자의 이름과 동일한 rt과 연결됨
  for_each = lookup(local.network, "subnets", {})

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}


#
# Platform
#

resource "aws_security_group" "main" {
  for_each = local.sg_config

  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [each.value]

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidrs
    }
  }

  dynamic "egress" {
    for_each = each.key == "instance-service" ? [1] : []

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