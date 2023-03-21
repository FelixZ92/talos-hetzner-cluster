variable "cluster_name" {
  description = "prefix for cloud resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.cluster_name))
    error_message = "Value of cluster_name should be lowercase and can only contain alphanumeric characters and hyphens(-)."
  }
}

variable "control_plane_type" {
  default = "cx21"
  type    = string
}

variable "control_plane_replicas" {
  default = 3
  type    = number
}

variable "image" {
  type    = string
}

variable "network_id" {
  type = string
}

variable "datacenters" {
  default     = ["nbg1-dc3", "fsn1-dc14" , "hel1-dc2"]
  type        = list(string)
}

variable "cidr_offset" {
  type = number
}

variable "vpc_cidr" {
  type = string
}

variable "machine_secrets" {
  type = string
}

variable "loadbalancer_public_ip" {
  type = string
}

variable "loadbalancer_private_ip" {
  type = string
}

variable "cilium_deployment" {
  type = string
}