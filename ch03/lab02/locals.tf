locals {
  org     = "tf-core-ej"
  project = "gallery"

  namespace = "${local.org}-${local.project}"

  vpc_id = data.aws_vpc.default.id
  
  instance = {
    name = "web"

    ami                         = data.aws_ami.amazon_linux.id
    instance_type               = var.instance_type
    associate_public_ip_address = true
    subnet_id                   = data.aws_subnets.default.ids[0]

    user_data = base64encode(templatefile("templates/user_data.sh.tpl", {
      profile     = "dev"
      server_port = var.service_port
    }))
    
    allow_access = {
      port        = var.service_port
      cidr_blocks = var.cidr_blocks
    }
  }

  iamrole = {
    name = "instance-web"

    assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
    policy_arn         = data.aws_iam_policy.aws_ssm_core_policy.arn
  }

  s3bucket = {
    name   = "tfstate"
    bucket = "${local.org}-tfstate"

    versioning_configuration = {
      status = "Enabled"
    }

    public_access_block = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}
