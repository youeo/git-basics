output "module" {
  value = {
    network  = module.network
    platform = module.platform
    workload = module.workload
  }
}

output "lb" {
  value = {
    "main" = {
      # module.platform.aws_lb.this (X) -> module.platform.lb["main"] (O)
      # 모듈이 이미 내보낸 output "lb" 안의 값을 그대로 가져와 매핑합니다.
      dns_name = module.platform.lb["main"].dns_name

      listener = {
        port     = module.platform.lb["main"].listener.port
        protocol = module.platform.lb["main"].listener.protocol
      }

      target_group = {
        arn = module.platform.lb["main"].target_group.arn
        health_check = {
          path = module.platform.lb["main"].target_group.health_check.path
        }
      }
    }
  }
}

output "endpoint" {
  value = "${lower(module.platform.lb["main"].listener.protocol)}://${module.platform.lb["main"].dns_name}:${module.platform.lb["main"].listener.port}"
}