variable "cluster_name" {
  description = "prefix for cloud resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.cluster_name))
    error_message = "Value of cluster_name should be lowercase and can only contain alphanumeric characters and hyphens(-)."
  }
}

# Provider specific settings

variable "control_plane_type" {
  default = "cx21"
  type    = string
}

variable "control_plane_replicas" {
  default = 3
  type    = number
}

variable "worker_type" {
  default = "cpx21"
  type    = string
}

variable "worker_replicas" {
  description = "Number of replicas per MachineDeployment"
  default     = 3
  type        = number
}

variable "worker_datacenter" {
  default = "nbg1"
  type    = string
}

variable "lb_type" {
  default = "lb11"
  type    = string
}


variable "image" {
  default = "103681095" # talos 1.3.5 snapshot
  type    = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/8"
  description = "ip range to use for private network"
  type        = string
}

variable "network_zone" {
  default     = "eu-central"
  description = "network zone to use for private network"
  type        = string
}
