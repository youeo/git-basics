# vpc
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

# ngw
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

# subnet
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

# Platform — ALB, Target Group, Security Group
	resource "aws_lb" "main" {
	  name               = "${local.namespace}-alb"
	  internal           = false
	  load_balancer_type = "application"
	  security_groups    = [aws_security_group.main["lb-listener"].id]
	  subnets            = [for s in local.platform.lb.subnets : aws_subnet.main[s].id]
	
	  tags = {
	    Name = "${local.namespace}-alb"
	  }
	}
	
	resource "aws_lb_target_group" "main" {
	  name     = "${local.namespace}-tg"
	  port     = 8080
	  protocol = "HTTP"
	  vpc_id   = aws_vpc.main.id
	
	  health_check {
	    path                = "/"
	    port                = 8080
	    healthy_threshold   = 2
	    unhealthy_threshold = 3
	    timeout             = 5
	    interval            = 30
	  }
	
	  tags = {
	    Name = "${local.namespace}-tg"
	  }
	}
	
	resource "aws_lb_listener" "main" {
	  load_balancer_arn = aws_lb.main.arn
	  port              = 80
	  protocol          = "HTTP"
	
	  default_action {
	    type             = "forward"
	    target_group_arn = aws_lb_target_group.main.arn
	  }
	}

# Workload — EC2 ×2, IAM Role, Instance Profile
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
}

resource "aws_instance" "main" {
  for_each = toset(local.workload.instance.subnets)

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = local.workload.instance.type
  subnet_id                   = aws_subnet.main[each.value].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.main["instance-service"].id]
  iam_instance_profile        = aws_iam_instance_profile.this.name

  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    profile     = var.env
    server_port = 8080
  })

  depends_on = [aws_iam_role_policy_attachment.this]

  tags = {
    Name = "${local.namespace}-instance-${each.value}"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  for_each = toset(local.workload.instance.subnets)

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.main[each.value].id
  port             = 8080
}

resource "aws_iam_role" "this" {
  name = "${local.namespace}-iamrole-${local.iamrole.name}"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name = "${local.namespace}-iamrole-${local.iamrole.name}"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = local.iamrole.policy_arn
}


resource "aws_iam_instance_profile" "this" {
  name = "${local.namespace}-iamprofile-${local.iamrole.name}"

  role = aws_iam_role.this.name

  tags = {
    Name = "${local.namespace}-iamprofile-${local.iamrole.name}"
  }
}