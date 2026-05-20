locals {
  namespace = var.namespace

  vpc_id = var.vpc_id

  lb = {
    name = "main"

    load_balancer_type         = "application"
    internal                   = false
    enable_deletion_protection = false
    subnets                    = var.lb_subnets

    target_group = {
      port        = var.lb_target_group_port
      protocol    = "HTTP"
      target_type = "instance"

      health_check = {
        enabled             = true
        protocol            = "HTTP"
        path                = "/actuator/health"
        port                = var.lb_target_group_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
      }
    }

    listener = {
      port        = var.lb_listener_port
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "HTTP"
    }
  }

  iamrole = {
    name       = "lt-web"
    policy_arn = data.aws_iam_policy.aws_ssm_core_policy.arn
  }
}
