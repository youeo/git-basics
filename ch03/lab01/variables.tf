# variables.tf
variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "EC2 Instance Type (t3.micro, t3.small, t3.medium)"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "instance_type은 t3.micro, t3.small, t3.medium 중 하나여야 한다."
  }
}

variable "service_port" {
  type        = number
  default     = 8080
  description = "Service Port (1~65535)"

  validation {
    condition     = 1 <= var.service_port && var.service_port <= 65535
    error_message = "service_port는 1~65535 범위여야 한다."
  }
}

variable "cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Security Group Allowed CIDR Blocks"

  validation {
    condition     = length(var.cidr_blocks) > 0
    error_message = "cidr_blocks는 최소 1개 이상의 CIDR을 포함해야 한다."
  }
}