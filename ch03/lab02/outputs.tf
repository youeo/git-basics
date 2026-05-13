output "instance_web" {
  description = "Gallery EC2 인스턴스 정보"
  value = {
    id            = aws_instance.web.id
    public_ip     = aws_instance.web.public_ip
    http_endpoint = "http://${aws_instance.web.public_ip}:${var.service_port}"
  }
}