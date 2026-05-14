variable "namespace" {
  type        = string
  description = "Resource Naming Prefix"
}

variable "iamrole_name" {
  type        = string
  description = "IAMRole Name Tag"
}

variable "policy_arn" {
  type        = string
  description = "IAMPolicy Arn"
}