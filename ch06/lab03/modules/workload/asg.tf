# resource "aws_autoscaling_group" "web" {
#   name = "tf-core-gallery-dev-asg-web"
#
#   min_size         = 2
#   max_size         = 4
#   desired_capacity = 2
#
#   vpc_zone_identifier = ["subnet-0abc...", "subnet-0def..."]
#
#   target_group_arns = ["arn:aws:elasticloadbalancing:..."]
#
#   health_check_type         = "ELB"
#   health_check_grace_period = 600
#
#   launch_template {
#     id      = aws_launch_template.web.id
#     version = "$Latest"
#   }
# }
resource "aws_autoscaling_group" "this" {
  name = "${local.namespace}-asg-${local.asg.name}"

  min_size         = local.asg.min_size
  max_size         = local.asg.max_size
  desired_capacity = local.asg.desired_capacity

  vpc_zone_identifier = local.asg.vpc_zone_identifier

  target_group_arns = local.asg.target_group_arns

  health_check_type         = local.asg.health_check_type
  health_check_grace_period = local.asg.health_check_grace_period

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "DeployVersion"
    value               = "${local.namespace}-asg-${local.asg.deploy_version}"
    propagate_at_launch = true
  }
}

# resource "aws_launch_template" "web" {
#   name = "tf-core-gallery-dev-lt-web"
#
#   image_id               = "ami-0c003e98ceffee43e"
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [aws_security_group.instance_web.id]
#   update_default_version = true
#
#   iam_instance_profile {
#     name = "tf-core-gallery-dev-iamprofile-instance-web"
#   }
#
#   user_data = "base64(...user_data.sh.tpl...)"
#
#   tag_specifications {
#     resource_type = "instance"
#     tags = { Name = "tf-core-gallery-dev-instance-web" }
#   }
# }
resource "aws_launch_template" "this" {
  name = "${local.namespace}-lt-${local.lt.name}"

  image_id               = local.lt.image_id
  instance_type          = local.lt.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  update_default_version = true

  iam_instance_profile {
    name = local.lt.iam_instance_profile.name
  }

  user_data = local.lt.user_data

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.namespace}-instance-${local.lt.name}"
    }
  }

  tags = {
    Name = "${local.namespace}-lt-${local.lt.name}"
  }
}

resource "aws_security_group" "this" {
  name = "${local.namespace}-sg-lt-${local.lt.name}"

  vpc_id = local.vpc_id

  ingress {
    from_port   = local.lt.allow_access.port
    to_port     = local.lt.allow_access.port
    protocol    = "tcp"
    cidr_blocks = local.lt.allow_access.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.namespace}-sg-lt-${local.lt.name}"
  }
}