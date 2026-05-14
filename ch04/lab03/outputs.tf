output "module" {
  value = {
    network = module.network
    iam     = module.iam
  }
}