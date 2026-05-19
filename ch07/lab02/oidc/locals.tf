locals {
  org       = "tf-core-ej"
  project   = "lab02"
  namespace = "${local.org}-${local.project}"

  github_repo = "OWNER/REPO"

  iamrole = {
    name       = "gha"
    policy_arn = data.aws_iam_policy.admin_access.arn
  }

  iamoidcp = {
    name            = "gha"
    url             = "https://token.actions.githubusercontent.com"
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
  }
}