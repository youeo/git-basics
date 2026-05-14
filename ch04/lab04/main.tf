module "network" {
  source = "./modules/network"

  namespace = local.namespace
}

module "iam" {
  source = "./modules/iam"

  namespace = local.namespace
}

module "workload" {
  source = "./modules/workload"

  namespace = local.namespace

  instance_vpc_id               = module.network.vpc["main"].id
  instance_subnet_id            = module.network.subnet["public-a"].id
  instance_iam_instance_profile = module.iam.iamprofile["instance-web"].name
}