output "network" {
  value = {
    vpc_id = aws_vpc.main.id

    # natgw = local.network.natgw_enabled ? {
    #   id        = aws_nat_gateway.main[0].id
    #   subnet_id = aws_nat_gateway.main[0].subnet_id
    # } : {}
    
    # eip = local.network.natgw_enabled ? {
    #   id        = aws_eip.natgw[0].id
    #   public_ip = aws_eip.natgw[0].public_ip
    # } : {}

    subnet_public_a = {
      id         = aws_subnet.main["public-a"].id
      az         = aws_subnet.main["public-a"].availability_zone
      cidr_block = aws_subnet.main["public-a"].cidr_block
      
      route_table = {
        id    = aws_route_table.main["public-a"].id
        route = aws_route_table.main["public-a"].route
      }
    }

    subnet_public_b = {
      id         = aws_subnet.main["public-b"].id
      az         = aws_subnet.main["public-b"].availability_zone
      cidr_block = aws_subnet.main["public-b"].cidr_block
      
      route_table = {
        id    = aws_route_table.main["public-b"].id
        route = aws_route_table.main["public-b"].route
      }
    }

    subnet_private_c = {
      id         = aws_subnet.main["private-c"].id
      az         = aws_subnet.main["private-c"].availability_zone
      cidr_block = aws_subnet.main["private-c"].cidr_block
      
      route_table = {
        id    = aws_route_table.main["private-c"].id
        route = aws_route_table.main["private-c"].route
      }
    }

    subnet_private_d = {
      id         = aws_subnet.main["private-d"].id
      az         = aws_subnet.main["private-d"].availability_zone
      cidr_block = aws_subnet.main["private-d"].cidr_block
      
      route_table = {
        id    = aws_route_table.main["private-d"].id
        route = aws_route_table.main["private-d"].route
      }
    }
  }
}