variable "env" {
  type = string
}

variable "infra_lt_instance_type" {
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