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

resource "aws_subnet" "main" {
  for_each = local.network.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.namespace}-subnet-${each.key}"
  }
}

resource "aws_route_table" "main" {
  for_each = local.network.subnets

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.namespace}-rt-${each.key}"
  }
}

resource "aws_route_table_association" "main" {
  for_each = local.network.subnets

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}

resource "aws_eip" "natgw" {
  # count = local.network.eip_count
  # count = local.network.natgw_enabled ? 1 : 0
  for_each = toset(local.network.natgw_subnets)

  domain = "vpc"
  
  tags = {
    # Name = "${local.namespace}-eip-${count.index}"
    Name = "${local.namespace}-eip-natgw-${each.value}"
  }
}

resource "aws_nat_gateway" "main" {
  # count = local.network.natgw_enabled ? 1 : 0
  for_each = toset(local.network.natgw_subnets)

  # allocation_id = aws_eip.natgw[0].id
  allocation_id = aws_eip.natgw[each.value].id
  subnet_id     = aws_subnet.main[each.value].id

  tags = {
    Name = "${local.namespace}-natgw-${each.value}"
  }
}