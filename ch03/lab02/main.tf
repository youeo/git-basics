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

resource "aws_security_group" "this" {
  name = "${local.namespace}-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespace}-sg"
  }
}
