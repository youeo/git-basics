locals {
  org       = "tf-core"
  project   = "lab01"
  namespace = "${local.org}-${local.project}-${var.env}"

  network = {
    cidr = "10.0.0.0/16"
  }

  workload = {
    instance = {
      type    = "t3.micro"
      service = { port = 8080, cidrs = ["0.0.0.0/0"] }
      ssh     = { port = 22, cidrs = ["0.0.0.0/0"] }
    }
  }

# workload.instance에서 key가 service이거나 ssh인 항목만 추출해 list를 만듦
	# 원하는 규칙을 지정해서 추가할 수 있음 (동적)
  sg_config = [for k, v in local.workload.instance : v if k == "service" || k == "ssh"]
  }