variable "cluster_name" {
  description = "prefix for cloud resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.cluster_name))
    error_message = "Value of cluster_name should be lowercase and can only contain alphanumeric characters and hyphens(-)."
  }
}

variable "ssh_public_key" {
  description = "SSH public key file"
  type        = string
}

variable "ssh_username" {
  description = "SSH user, used in output and for ssh keys"
  default     = "devops"
  type        = string
}

variable "bastion_type" {
  default = "cx11"
  type    = string
}

variable "datacenter" {
  default = "nbg"
  type    = string
}

variable "bastion_image" {
  default = "ubuntu-20.04"
  type    = string
}

variable "network_id" {
  type = string
}
