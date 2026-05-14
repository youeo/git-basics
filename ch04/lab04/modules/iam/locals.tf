locals {
  namespace = var.namespace

  iamrole = {
    name       = "instance-web"
    policy_arn = data.aws_iam_policy.aws_ssm_core_policy.arn
  }
}