output "aws_security_group_main" {
  value = {
	  # 외부 for문은 SG들을 순회하고 내부 for문은 규칙을 순회
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