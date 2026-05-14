variable "namespace" {
  type        = string
  description = "Resource Naming Prefix"
}

variable "name" {
  type        = string
  description = "Subnet Name Tag"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID"
}

variable "availability_zone" {
  type        = string
  description = "Target Availability Zone"
}

variable "cidr_block" {
  type        = string
  description = "Subnet CIDR Block"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Public IP Auto-assignment Policy"
}
