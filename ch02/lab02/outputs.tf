output "instance" {
	# 인스턴스의 이름을 키로 사용함 (반복문으로 만들 시 어떤 리소스의 데이터인지 파악이 쉬워짐)
  value = {
    (local.instance.name) = {
      id        = aws_instance.this.id
      public_ip = aws_instance.this.public_ip
    }
  }
}

output "iamrole" {
  value = {
    (local.iamrole.name) = {
      arn = aws_iam_role.this.arn
    }
  }
}

output "iamprofile" {
  value = {
    (local.iamrole.name) = {
      name = aws_iam_instance_profile.this.name
    }
  }
}

output "sg" {
  value = {
    id   = aws_security_group.this.id
    name = aws_security_group.this.name

		# 하나의 보안 그룹에 여러 개의 인바운드 규칙이 있을 수 있으므로 반복문 사용으로 데이터 추출
    ingress = [for v in aws_security_group.this.ingress : {
      from_port   = v.from_port
      to_port     = v.to_port
      protocol    = v.protocol
      cidr_blocks = v.cidr_blocks
    }]
  }
}

output "web_endpoint" {
  value = "http://${aws_instance.this.public_ip}:${local.instance.allow_access.port}"
}