output "network" {
  value = {
    vpc_id = aws_vpc.main.id
    
    eips_0 = {
      id        = aws_eip.main[0].id
      public_ip = aws_eip.main[0].public_ip
    }

    eips_1 = {
      id        = aws_eip.main[1].id
      public_ip = aws_eip.main[1].public_ip
    }
  }
}
