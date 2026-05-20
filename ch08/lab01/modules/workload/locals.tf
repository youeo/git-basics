locals {
  namespace = var.namespace

  vpc_id = var.vpc_id

  asg = {
    name = "web"

    min_size         = var.asg_min_size
    max_size         = var.asg_max_size
    desired_capacity = var.asg_desired_capacity

    vpc_zone_identifier = var.asg_vpc_zone_identifier
    target_group_arns   = var.asg_target_group_arns

    health_check_type         = "ELB"
    health_check_grace_period = 600

    deploy_version = var.asg_deploy_version
  }

  lt = {
    name = "web"

    image_id      = data.aws_ami.amazon_linux.id
    instance_type = var.lt_instance_type

    iam_instance_profile = {
      name = var.lt_iam_instance_profile_name
    }

    user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
      profile     = "dev"
      server_port = var.lt_service_port
    }))

    allow_access = {
      port        = var.lt_service_port
      cidr_blocks = var.lt_allow_access_cidr_blocks
    }
  }
}