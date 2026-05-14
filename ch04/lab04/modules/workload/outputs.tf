output "instance" {
  value = {
    (local.instance.name) = {
      id        = aws_instance.this.id
      public_ip = aws_instance.this.public_ip

      allow_access = [
        for v in aws_security_group.this.ingress : {
          from_port   = v.from_port
          to_port     = v.to_port
          protocol    = v.protocol
          cidr_blocks = v.cidr_blocks
        }
      ]
    }
  }
}