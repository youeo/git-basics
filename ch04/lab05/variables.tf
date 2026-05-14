variable "env" {
  description = "배포 환경 - lab"
  type        = string
  default     = "lab" # 기본값을 지정하면 apply 시 묻지 않습니다.
}