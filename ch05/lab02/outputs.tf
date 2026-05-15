output "aws_security_group_instance" {
  value = {
    id = aws_security_group.instance.id

    ingress = [for rule in aws_security_group.instance.ingress : {
      from_port   = rule.from_port
      to_port     = rule.to_port
      protocol    = rule.protocol
      cidr_blocks = rule.cidr_blocks
    }]

    egress = [for rule in aws_security_group.instance.egress : {
      from_port   = rule.from_port
      to_port     = rule.to_port
      protocol    = rule.protocol
      cidr_blocks = rule.cidr_blocks
    }]
  }
}