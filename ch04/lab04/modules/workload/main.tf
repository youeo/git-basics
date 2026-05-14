# resource "aws_security_group" "instance_web" {
#   name        = "tf-core-lab03-dev-sg-instance-web"
#   vpc_id      = "vpc-0abc1234567890def"
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
resource "aws_security_group" "this" {
  name   = "${local.namespace}-sg-instance-${local.instance.name}"
  vpc_id = local.instance.vpc_id

  ingress {
    from_port   = local.instance.allow_access.port
    to_port     = local.instance.allow_access.port
    protocol    = "tcp"
    cidr_blocks = local.instance.allow_access.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespace}-sg-instance-${local.instance.name}"
  }
}

# resource "aws_instance" "web" {
#   ami                         = "ami-0ada8527e6dc686a3"
#   instance_type               = "t3.small"
#   subnet_id                   = "subnet-0abc1234567890def"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.instance_web.id]
#   iam_instance_profile        = "tf-core-lab03-dev-iamprofile-instance-web"
# }
resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance.instance_type

  subnet_id                   = local.instance.subnet_id
  associate_public_ip_address = true

  iam_instance_profile = local.instance.iam_instance_profile

  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "${local.namespace}-instance-${local.instance.name}"
  }
}