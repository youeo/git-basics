variable "namespace" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "asg_vpc_zone_identifier" {
  type = list(string)
}

variable "asg_target_group_arns" {
  type = list(string)
}

variable "asg_deploy_version" {
  type    = string
  default = "1.0.0"
}

variable "asg_min_size" {
  type = number
}

variable "asg_max_size" {
  type = number
}

variable "asg_desired_capacity" {
  type = number
}

variable "lt_iam_instance_profile_name" {
  type = string
}

variable "lt_service_port" {
  type = number
}

variable "lt_allow_access_cidr_blocks" {
  type = list(string)
}

variable "lt_instance_type" {
  type = string
}