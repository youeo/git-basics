locals {
  org         = "tf-core-ej"
  project     = "gallery5"
  environment = var.env

  namespace = "${local.org}-${local.project}-${local.environment}"

  infra = {
    lb = {
      listener_port = 80                                # infra fact (하드코딩)
    }

    lt = {
      service_port  = 8080                              # infra fact (하드코딩)
      instance_type = var.infra_lt_instance_type        # env factor (variable)
    }

    asg = {
      deploy_version   = "1.0.0"                        # infra fact (하드코딩)
      min_size         = var.infra_asg_min_size         # env factor
      max_size         = var.infra_asg_max_size         # env factor
      desired_capacity = var.infra_asg_desired_capacity # env factor
    }
  }
}