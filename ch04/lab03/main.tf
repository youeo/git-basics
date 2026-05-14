module "network" {
  source = "./modules/network"

  namespace   = local.namespace
  vpc_name    = "main"
  vpc_cidr    = "10.0.0.0/16"
  subnet_name              = "public-a"
  subnet_availability_zone = "ap-northeast-2a"
  subnet_cidr_block        = "10.0.1.0/24"
}

module "iam" {
  source = "./modules/iam"

  namespace = local.namespace

  iamrole_name  = "instance-web"
  policy_arn = data.aws_iam_policy.aws_ssm_core_policy.arn
}