resource "aws_iam_role" "this" {
  name = "${local.namespace}-iamrole-${local.iamrole.name}"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name = "${local.namespace}-iamrole-${local.iamrole.name}"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = local.iamrole.policy_arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.namespace}-iamprofile-${local.iamrole.name}"

  role = aws_iam_role.this.name

  tags = {
    Name = "${local.namespace}-iamprofile-${local.iamrole.name}"
  }
}
