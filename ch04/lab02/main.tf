# 각 모듈의 variable에 값을 넘겨주기
module "vpc" {
  source    = "./modules/vpc"
  namespace = local.namespace
  name      = "main"
  cidr_block = "10.0.0.0/16"
}

module "subnet" {
  source    = "./modules/subnet"
  namespace = local.namespace
  name      = "public-a"
  vpc_id            = module.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
}
