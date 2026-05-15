locals {
  org       = "tf-core-ej"
  project   = "gallery4"
  namespace = "${local.org}-${local.project}"

  network = {
    cidr = "10.0.0.0/16"
    subnets = {
      "public-a"  = { az = "ap-northeast-2a", cidr = cidrsubnet("10.0.0.0/16", 8, 1) }
      "public-b"  = { az = "ap-northeast-2b", cidr = cidrsubnet("10.0.0.0/16", 8, 2) }
      "private-c" = { az = "ap-northeast-2c", cidr = cidrsubnet("10.0.0.0/16", 8, 101), ref_natgw_subnet = "public-a" }
      "private-d" = { az = "ap-northeast-2d", cidr = cidrsubnet("10.0.0.0/16", 8, 102), ref_natgw_subnet = "public-a" }
    }
    natgw_subnets = ["public-a"]
  }

  platform = {
    lb = {
      subnets  = ["public-a", "public-b"]
      listener = { port = 80, cidrs = ["0.0.0.0/0"] }
    }
  }

  workload = {
    instance = {
      type    = "t3.small"
      subnets = ["public-a", "public-b"]
      service = { port = 8080, cidrs = ["0.0.0.0/0"] }
    }
  }

  sg_config = merge({
    for k, v in lookup(local.platform, "lb", {}) : "lb-${k}" => v
      if k == "listener" && can(v.port) && can(v.cidrs)
  }, {
    for v in [try(local.workload.instance.service, null)] : "instance-service" => v
      if v != null && can(v.port) && can(v.cidrs)
  })

  iamrole = {
    name       = "lt-web"
    policy_arn = data.aws_iam_policy.aws_ssm_core_policy.arn
  }
}
