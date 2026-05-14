resource "aws_iam_role" "this" {
  name               = "${local.project}-iamrole-${local.iamrole.name}"
  assume_role_policy = local.iamrole.assume_role_policy

  tags = {
    Name = "${local.project}-iamrole-${local.iamrole.name}"
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.project}-iamprofile-${local.iamrole.name}"
  role = aws_iam_role.this.name

  tags = {
    Name = "${local.project}-iamprofile-${local.iamrole.name}"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = local.iamrole.policy_arn
}

resource "aws_security_group" "this" {
  name   = "${local.project}-sg-instance-${local.instance.name}"
  vpc_id = local.vpc_id

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
    Name = "${local.project}-sg-instance-${local.instance.name}"
  }
}

resource "aws_instance" "web" {
  ami                         = local.instance.ami
  instance_type               = local.instance.instance_type
  subnet_id                   = local.instance.subnet_id
  associate_public_ip_address = local.instance.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name

  user_data_replace_on_change = true
  user_data = local.instance.user_data

  depends_on = [aws_iam_role_policy_attachment.this]

  tags = {
    Name = "${local.namespace}-instance-web"
  }
}

# resource "aws_s3_bucket" "tfstate" {
#   bucket = "tf-core-tfstate"
# }
resource "aws_s3_bucket" "this" {
  bucket = local.s3bucket.bucket

  tags = {
    Name = "${local.namespace}-s3bucket-${local.s3bucket.name}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# resource "aws_s3_bucket_versioning" "tfstate" {
#   bucket = aws_s3_bucket.tfstate.id
#   versioning_configuration { status = "Enabled" }
# }
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.s3bucket.versioning_configuration.status
  }
}

# resource "aws_s3_bucket_public_access_block" "tfstate" {
#   bucket = aws_s3_bucket.tfstate.id
#   block_public_acls = true
#   block_public_policy = true
#   ignore_public_acls = true
#   restrict_public_buckets = true
# }
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = local.s3bucket.public_access_block.block_public_acls
  block_public_policy     = local.s3bucket.public_access_block.block_public_policy
  ignore_public_acls      = local.s3bucket.public_access_block.ignore_public_acls
  restrict_public_buckets = local.s3bucket.public_access_block.restrict_public_buckets
}