variable "namespace" {
  type        = string
  description = "Resource Naming Prefix"
}

variable "name" {
  type        = string
  description = "VPC Name Tag"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR Block"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "VPC DNS Resolution Identifier"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "VPC Resource Hostname Assignment"
}
