locals {
  org       = "tf-core"
  project   = "lab02"
  namespace = "${local.org}-${local.project}-${var.env}"

  network = {
    cidr = "10.0.0.0/16"
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
    for k, v in local.platform.lb : "lb-${k}" => v if k == "listener"
  }, {
    for k, v in local.workload.instance : "instance-${k}" => v if k == "service"
  })
}