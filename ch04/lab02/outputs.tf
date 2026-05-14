output "vpc" {
  value = {
    id = module.vpc.id
  }
}

output "subnet" {
  value = {
    id = module.subnet.id
  }
}
