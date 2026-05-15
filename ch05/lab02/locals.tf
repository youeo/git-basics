locals {
  org       = "tf-core"
  project   = "lab02"
  namespace = "${local.org}-${local.project}-${var.env}"

  network = {
    cidr = "10.0.0.0/16"
    subnets = {
      "public-a"  = { az = "ap-northeast-2a", cidr = cidrsubnet("10.0.0.0/16", 8, 1) }
      "public-b"  = { az = "ap-northeast-2b", cidr = cidrsubnet("10.0.0.0/16", 8, 2) }
      "private-c" = { az = "ap-northeast-2c", cidr = cidrsubnet("10.0.0.0/16", 8, 101), ref_natgw_subnet = "public-a" }
      "private-d" = { az = "ap-northeast-2d", cidr = cidrsubnet("10.0.0.0/16", 8, 102), ref_natgw_subnet = "public-a" }
    }
    # 여기에 subnet을 더 추가하면 여러개 생성 가능
    natgw_subnets = ["public-a"]
  }

  platform = {
    lb = {
      subnets  = ["public-a"]
      listener = {
        port  = 80
        cidrs = ["0.0.0.0/0"]
      }
    }
  }

  workload = {
    instance = {
      type    = "t3.micro"
      service = {
        port  = 8080
        cidrs = ["0.0.0.0/0"]
      }
    }
  }

  sg_config = merge({
    # lookup으로 lb 설정 없어도 오류 없이 빈 map 반환 가능
    # can으로 port, cidr이 있는것만 들어갈 수 있게 설정
    for k, v in lookup(local.platform, "lb", {}) : "lb-${k}" => v
      if k == "listener" && can(v.port) && can(v.cidrs)
  }, {
    # service가 없으면 null이 반환되고 하단 if문에 의해 포함되지 않음
    for v in [try(local.workload.instance.service, null)] : "instance-service" => v
      if v != null && can(v.port) && can(v.cidrs)
  })
}