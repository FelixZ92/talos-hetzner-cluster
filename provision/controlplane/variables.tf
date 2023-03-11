locals {
  kubeapi_endpoint   = var.loadbalancer_count == 0 ? hcloud_server_network.control_plane.0.ip : hcloud_load_balancer.load_balancer.0.network_ip
}
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

variable "lb_type" {
  default = "lb11"
  type    = string
}

variable "image" {
  type    = string
}

variable "network_id" {
  type = string
}

variable "datacenters" {
  default     = ["nbg", "fsn" , "hel"]
  type        = list(string)
}

variable "loadbalancer_count" {
  type = number
  default = 1
}
