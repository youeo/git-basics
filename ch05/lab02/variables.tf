variable "env" {
  type        = string
  default     = "dev"
  description = "배포 환경"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.env)
    error_message = "env는 dev, stg, prod 중 하나여야 한다."
  }
}
