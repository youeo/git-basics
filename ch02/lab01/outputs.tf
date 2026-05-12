output "sg_instance_id" {
  value = aws_security_group.instance.id
}

output "sg_instance_name" {
  value = aws_security_group.instance.name
}

output "sg_instance_tags_all" {
  value = aws_security_group.instance.tags_all
}