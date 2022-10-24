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

variable "hub_subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "backend_subscription_id" {
  type = string
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

variable "address_space" {
  type    = string
  default = "192.168.255.0/24"
}

variable "workload_admin_username" {
  type    = string
  default = "azure"
}

variable "workload_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "workload_image_reference" {
  type    = string
  default = "Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
