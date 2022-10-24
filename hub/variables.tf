variable "project" {
  type = string
}

variable "location" {
  type = object({
    name = string
    code = string
  })
}

variable "environment" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "spoke_subscription_id" {
  type = string
}

variable "address_space" {
  type    = string
  default = "192.168.0.0/24"
}

variable "bastion_scale_units" {
  type    = number
  default = 2
}

variable "private_dns_zones" {
  type    = set(string)
  default = []
}

variable "backend_resource_group_name" {
  type = string
}

variable "backend_storage_account_name" {
  type = string
}

variable "backend_container_name" {
  type = string
}
