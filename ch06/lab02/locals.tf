locals {
  org         = "tf-core-ej"
  project     = "lab02"
  environment = terraform.workspace

  namespace = "${local.org}-${local.project}-${local.environment}"

  vpc_id = data.aws_vpc.default.id

  instance = {
    name = "web"

    ami                         = data.aws_ami.amazon_linux.id
    instance_type               = local.environment == "dev" ? "t3.micro" : "t3.small"
    associate_public_ip_address = true
    subnet_id                   = data.aws_subnets.default.ids[0]

    allow_access = {
      port = 80
      # 테라폼에서 cidr_block은 대괄호가 자동으로 붙으니까 써줄 필요 없음
      cidr_blocks = local.environment == "dev" ? "218.10.1.0/32" : "0.0.0.0/0"
    }
  }

  iamrole = {
    name = "instance"

    assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
    policy_arn         = data.aws_iam_policy.aws_ssm_core_policy.arn
  }
}