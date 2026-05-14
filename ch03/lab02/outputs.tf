output "s3bucket" {
  value = {
    (local.s3bucket.name) = {
      bucket = aws_s3_bucket.this.bucket
      arn    = aws_s3_bucket.this.arn
    }
  }
}

output "instance_web" {
  description = "Gallery EC2 인스턴스 정보"
  value = {
    id            = aws_instance.this.id
    public_ip     = aws_instance.this.public_ip
    http_endpoint = "http://${aws_instance.this.public_ip}:${var.service_port}"
  }
}