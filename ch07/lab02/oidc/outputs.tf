output "iamrole" {
  value = {
    (local.iamrole.name) = {
      arn = aws_iam_role.this.arn
    }
  }
}