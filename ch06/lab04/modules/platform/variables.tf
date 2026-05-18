variable "namespace" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "lb_target_group_port" {
  type = number
}

variable "lb_subnets" {
  type = list(string)
}

variable "lb_listener_port" {
  type = number
}
