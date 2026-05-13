output "s3bucket" {
  value = {
    (local.s3bucket.name) = {
      bucket = aws_s3_bucket.this.bucket
      arn    = aws_s3_bucket.this.arn
    }
  }
}

output "sg" {
  value = {
    id   = aws_security_group.this.id
    name = aws_security_group.this.name
  }
}