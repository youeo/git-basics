resource "aws_iam_role" "this" {
  name = "${local.project}-iamrole-instance-minimal"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${local.project}-iamrole-instance-minimal"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.project}-iamprofile-instance-minimal"

  role = aws_iam_role.this.name

  tags = {
    Name = "${local.project}-iamprofile-instance-minimal"
  }
}

resource "aws_security_group" "this" {
  name = "${local.project}-sg-instance-minimal"

  ingress {
    from_port   = local.allow_access.port
    to_port     = local.allow_access.port
    protocol    = "tcp"
    cidr_blocks = local.allow_access.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project}-sg-instance-minimal"
  }
}

resource "aws_instance" "this" {
  ami                    = "ami-0c003e98ceffee43e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile = aws_iam_instance_profile.this.name
  depends_on           = [aws_iam_role_policy_attachment.this]

  tags = {
    Name = "${local.project}-instance-minimal"
  }
}