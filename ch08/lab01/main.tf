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
  lb_target_group_port = local.infra.lt.service_port
}

module "workload" {
  source = "./modules/workload"

  namespace = local.namespace

  vpc_id = module.network.vpc["main"].id

  asg_vpc_zone_identifier = [module.network.subnet["private-a"].id, module.network.subnet["private-b"].id]
  asg_target_group_arns   = [module.platform.lb["main"].target_group.arn]
  asg_deploy_version      = local.infra.asg.deploy_version
  asg_min_size            = local.infra.asg.min_size
  asg_max_size            = local.infra.asg.max_size
  asg_desired_capacity    = local.infra.asg.desired_capacity

  lt_service_port              = local.infra.lt.service_port
  lt_allow_access_cidr_blocks  = [module.network.subnet["public-a"].cidr_block, module.network.subnet["public-b"].cidr_block]
  lt_iam_instance_profile_name = module.platform.iamprofile["lt-web"].name
  lt_instance_type             = local.infra.lt.instance_type
}

check "gallery_health" {
  data "http" "app" {
    url = "${lower(module.platform.lb["main"].listener.protocol)}://${module.platform.lb["main"].dns_name}:${module.platform.lb["main"].listener.port}${module.platform.lb["main"].target_group.health_check.path}"
  }

  # check block은 실패해도 warning만 출력 (중단 없음)
  assert {
    condition     = data.http.app.status_code == 200
    error_message = "Gallery 앱이 정상 응답하지 않는다: ${data.http.app.url}"
  }

  assert {
    condition     = jsondecode(data.http.app.response_body).status == "UP"
    error_message = "Gallery 앱 상태가 UP이 아니다."
  }
}