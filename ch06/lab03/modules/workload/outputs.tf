output "asg" {
  value = {
    (local.asg.name) = {
      id             = aws_autoscaling_group.this.id
      arn            = aws_autoscaling_group.this.arn
      deploy_version = local.asg.deploy_version
    }
  }
}

output "lt" {
  value = {
    (local.lt.name) = {
      id  = aws_launch_template.this.id
      arn = aws_launch_template.this.arn
    }
  }
}