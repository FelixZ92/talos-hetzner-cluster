variable "network_id" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "pool_name" {
  type = string
}

variable "worker_type" {
  type = string
}

variable "image" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "placement_group" {
  type = string
}

variable "loadbalancer_private_ip" {
  type = string
}

variable "loadbalancer_public_ip" {
  type = string
}

variable "machine_secrets" {
  type = string
}

variable "vpc_cidr" {
  type = string
}
