# resource "aws_iam_role" "this" {
#   name               = "tf-core-lab02-dev-iamrole-instance-web"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action    = "sts:AssumeRole"
#       Effect    = "Allow"
#       Principal = { Service = "ec2.amazonaws.com" }
#     }]
#   })
resource "aws_iam_role" "this" {
  name               = "${var.namespace}-iamrole-${var.iamrole_name}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name = "${var.namespace}-iamrole-${var.iamrole_name}"
  }
}

# resource "aws_iam_role_policy_attachment" "this" {
#   role       = aws_iam_role.this.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}

# resource "aws_iam_instance_profile" "this" {
#   name = "tf-core-lab02-dev-iamprofile-instance-web"
#   role = aws_iam_role.this.name
# }
resource "aws_iam_instance_profile" "this" {
  name = "${var.namespace}-iamprofile-${var.iamrole_name}"
  role = aws_iam_role.this.name

  tags = {
    Name = "${var.namespace}-iamprofile-${var.iamrole_name}"
  }
}