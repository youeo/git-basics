output "iamprofile" {
  value = {
    (local.iamrole.name) = {
      name = aws_iam_instance_profile.this.name
    }
  }
}

output "lb" {
  value = {
    (local.lb.name) = {
      dns_name = aws_lb.this.dns_name

      listener = {
        port     = aws_lb_listener.this.port
        protocol = aws_lb_listener.this.protocol
      }

      target_group = {
        arn = aws_lb_target_group.this.arn
      }
    }
  }
}
