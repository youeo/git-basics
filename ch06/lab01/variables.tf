variable "environment" {
  type = string
}

variable "infra_db_username" {
  type      = string
  sensitive = true
}

variable "infra_db_password" {
  type      = string
  sensitive = true
}

variable "infra_lb_listener_port" {
  type = number
}

variable "infra_lt_service_port" {
  type = number
}

variable "infra_lt_instance_type" {
  type = string
}

variable "infra_asg_deploy_version" {
  type = string
}

variable "infra_asg_max_size" {
  type = number
}

variable "infra_asg_min_size" {
  type = number
}

variable "infra_asg_desired_capacity" {
  type = number
}