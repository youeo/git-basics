# resource "aws_lb" "this" {
#   name               = "tf-core-lab03-dev-lb-main"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = ["subnet-0abc...", "subnet-0def..."]
#   security_groups    = [aws_security_group.this.id]
# }
resource "aws_lb" "this" {
  name = "${local.namespace}-lb-${local.lb.name}"

  internal                   = local.lb.internal
  load_balancer_type         = local.lb.load_balancer_type
  enable_deletion_protection = local.lb.enable_deletion_protection

  subnets         = local.lb.subnets
  security_groups = [aws_security_group.this.id]

  tags = {
    Name = "${local.namespace}-lb-${local.lb.name}"
  }
}

# resource "aws_lb_target_group" "this" {
#   name        = "tf-core-lab03-dev-tg-main"
#   port        = 8080
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = "vpc-0abc..."
# }
resource "aws_lb_target_group" "this" {
  name = "${local.namespace}-tg-${local.lb.name}"

  vpc_id      = local.vpc_id
  port        = local.lb.target_group.port
  protocol    = local.lb.target_group.protocol
  target_type = local.lb.target_group.target_type

  health_check {
    enabled             = local.lb.target_group.health_check.enabled
    port                = local.lb.target_group.health_check.port
    protocol            = local.lb.target_group.health_check.protocol
    path                = local.lb.target_group.health_check.path
    healthy_threshold   = local.lb.target_group.health_check.healthy_threshold
    unhealthy_threshold = local.lb.target_group.health_check.unhealthy_threshold
    timeout             = local.lb.target_group.health_check.timeout
    interval            = local.lb.target_group.health_check.interval
  }

  tags = {
    Name = "${local.namespace}-tg-${local.lb.name}"
  }
}

# resource "aws_lb_listener" "this" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }
resource "aws_lb_listener" "this" {
  port     = local.lb.listener.port
  protocol = local.lb.listener.protocol

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "this" {
  name   = "${local.namespace}-sg-lb-${local.lb.name}"
  vpc_id = local.vpc_id

  ingress {
    to_port     = local.lb.listener.port
    from_port   = local.lb.listener.port
    cidr_blocks = local.lb.listener.cidr_blocks
    protocol    = "tcp"
  }

  egress {
    to_port     = 0
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "${local.namespace}-sg-lb-${local.lb.name}"
  }
}