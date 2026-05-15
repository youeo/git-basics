locals {
  org       = "tf-core-ej"
  project   = "lab01"
  namespace = "${local.org}-${local.project}-${var.env}"

  # network = {
  #   cidr          = "10.0.0.0/16"
  #   #eip_count    = 2
  #   natgw_enabled = true
  # }

  network = {
    cidr = "10.0.0.0/16"
    subnets = {
      "public-a"  = { az = "ap-northeast-2a", cidr = "10.0.1.0/24" }
      "public-b"  = { az = "ap-northeast-2b", cidr = "10.0.2.0/24" }
      "private-c" = { az = "ap-northeast-2c", cidr = "10.0.101.0/24" }
      "private-d" = { az = "ap-northeast-2d", cidr = "10.0.102.0/24" }
    }
    natgw_subnets = ["public-a", "public-b"]
  }
}