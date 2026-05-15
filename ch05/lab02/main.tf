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

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
	  # for expression으로 전처리된 값을 받아옴
    for_each = toset(local.sg_config)
    
    # iterator가 생략됐으므로 블록 이름(ingress)가 접근자가 됨

    content {
	    # <인수> = <iterator>.value.<속성>
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidrs
    }
  }

	# 얘는 모든 타입의 보안 그룹에 들어가는 내용이라 블록 밖에서 설정
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespace}-sg-instance"
  }
}