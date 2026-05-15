output "network" {
  value = {
  
    vpc = {
      id = aws_vpc.main.id
    }

    natgw = {
      for k, v in aws_nat_gateway.main : k => {
        id            = v.id
        subnet_id     = v.subnet_id
        allocation_id = v.allocation_id
        
        eip = {
          id        = aws_eip.natgw[k].id
          public_ip = aws_eip.natgw[k].public_ip
        }
      }
    }

    subnet = {
      for k in keys(aws_subnet.main) : k => {
        id   = aws_subnet.main[k].id
        az   = aws_subnet.main[k].availability_zone
        cidr = aws_subnet.main[k].cidr_block
        
        route_table = {
          id     = aws_route_table.main[k].id
          routes = [for r in aws_route_table.main[k].route : {
            cidr_block     = r.cidr_block
            gateway_id     = r.gateway_id
            nat_gateway_id = r.nat_gateway_id
          }]
        }
      }
    }
  }
}

output "platform" {
  value = {
    sg = {
      for k, v in aws_security_group.main : k => {
        id = v.id
        
        ingress = [for r in v.ingress : {
          from_port   = r.from_port
          to_port     = r.to_port
          protocol    = r.protocol
          cidr_blocks = r.cidr_blocks
        }]
        
        egress = [for r in v.egress : {
          from_port   = r.from_port
          to_port     = r.to_port
          protocol    = r.protocol
          cidr_blocks = r.cidr_blocks
        }]
      }
    }
  }
}