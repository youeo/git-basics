variable "namespace" {
  type        = string
  description = "Resource Naming Prefix"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name Tag"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "vpc_enable_dns_support" {
  type        = bool
  default     = true
  description = "VPC DNS Resolution Identifier"
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "VPC Resource Hostname Assignment"
}

variable "subnet_name" {
  type        = string
  description = "Subnet Name Tag"
}

variable "subnet_availability_zone" {
  type        = string
  description = "Target Availability Zone"
}

variable "subnet_cidr_block" {
  type        = string
  description = "Subnet CIDR Block"
}

variable "subnet_map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Public IP Auto-assignment Policy"
}