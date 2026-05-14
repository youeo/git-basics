module "network" {
  source = "./modules/network"

  namespace = local.namespace
}

module "platform" {
  source = "./modules/platform"

  namespace = local.namespace

  vpc_id = module.network.vpc["main"].id

  lb_subnets           = [module.network.subnet["public-a"].id, module.network.subnet["public-b"].id]
  lb_listener_port     = local.infra.lb.listener_port
  lb_target_group_port = local.infra.instance.service_port
}

module "workload" {
  source = "./modules/workload"

  namespace = local.namespace

  vpc_id = module.network.vpc["main"].id

  asg_vpc_zone_identifier = [module.network.subnet["private-a"].id, module.network.subnet["private-b"].id]
  asg_target_group_arns   = [module.platform.lb["main"].target_group.arn]
  asg_deploy_version      = local.infra.instance.deploy_version

  lt_service_port              = local.infra.instance.service_port
  lt_allow_access_cidr_blocks  = [module.network.subnet["public-a"].cidr_block, module.network.subnet["public-b"].cidr_block]
  lt_iam_instance_profile_name = module.platform.iamprofile["lt-web"].name
}