provider "hcloud" {}

locals {
  loadbalancer_count = var.disable_kubeapi_loadbalancer ? 0 : 1
}

module "bastion" {
  source       = "./bastion"
  cluster_name = var.cluster_name

  network_id     = hcloud_network_subnet.subnet.network_id
  ssh_public_key = var.ssh_public_key
}

module "controlplane" {
  source = "./controlplane"

  cluster_name = var.cluster_name
  image        = var.image
  network_id   = hcloud_network_subnet.subnet.network_id
}

module "worker" {
  count = 1
  source = "./worker"
  cluster_name = var.cluster_name
  image = var.image
  network_id = hcloud_network_subnet.subnet.network_id
  pool_name = "pool-1"
  datacenter = "nbg1"
}
