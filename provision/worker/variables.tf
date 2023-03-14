variable "cluster_name" {
  description = "prefix for cloud resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.cluster_name))
    error_message = "Value of cluster_name should be lowercase and can only contain alphanumeric characters and hyphens(-)."
  }
}

variable "worker_type" {
  default = "cx21"
  type    = string
}

variable "worker_replicas" {
  default = 3
  type    = number
}

variable "lb_type" {
  default = "lb11"
  type    = string
}

variable "image" {
  type = string
}

variable "network_id" {
  type = string
}

variable "datacenter" {
  default = "nbg1"
  type    = string
}

variable "pool_name" {
  type = string
}

variable "cidr_offset" {
  type = number
}

variable "worker_config" {
  type = string
}

variable "vpc_cidr" {
  type = string
}
