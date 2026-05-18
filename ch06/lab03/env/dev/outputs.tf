output "module" {
  value = {
    network  = module.network
    platform = module.platform
    workload = module.workload
  }
}

output "endpoint" {
  value = "${lower(module.platform.lb["main"].listener.protocol)}://${module.platform.lb["main"].dns_name}:${module.platform.lb["main"].listener.port}"
}