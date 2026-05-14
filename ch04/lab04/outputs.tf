output "module" {
  value = {
    network  = module.network
    iam      = module.iam
    workload = module.workload
  }
}