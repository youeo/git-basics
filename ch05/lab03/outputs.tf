output "alb" {
  value = {
    dns_name      = aws_lb.main.dns_name
    http_endpoint = "http://${aws_lb.main.dns_name}"
  }
}

output "instances" {
  value = {
    for k, v in aws_instance.main : k => {
      id        = v.id
      public_ip = v.public_ip
      subnet_id = v.subnet_id
    }
  }
}
