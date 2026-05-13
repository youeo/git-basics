# 타입 시스템 확인 (필수 파일은 아님)
variable "env" {
  type        = string
  description = "Deployment Env."
}

variable "listener_port" {
  type = number
  default = 8080
}

variable "enabled" {
  type = bool
  default = true
}