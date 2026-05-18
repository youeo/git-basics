output "infra_db" {
  value     = local.infra.db
  sensitive = true
}

output "infra_lb" {
  value = local.infra.lb
}

output "infra_lt" {
  value = local.infra.lt
}

output "infra_asg" {
  value = local.infra.asg
}