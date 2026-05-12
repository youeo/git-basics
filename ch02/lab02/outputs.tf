output "instance_minimal_id" {
  value = aws_instance.minimal.id
}

output "instance_minimal_public_ip" {
  value = aws_instance.minimal.public_ip
}

output "iam_role_instance_minimal_name" {
  value = aws_iam_role.instance_minimal.name
}

output "iam_role_instance_minimal_arn" {
  value = aws_iam_role.instance_minimal.arn
}