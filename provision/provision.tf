provider "hcloud" {}

locals {
  loadbalancer_count = var.disable_kubeapi_loadbalancer ? 0 : 1
}

module "controlplane" {
  source = "./controlplane"

  cluster_name = var.cluster_name
  image        = var.image
  network_id   = hcloud_network_subnet.subnet.id
  depends_on = [hcloud_network_subnet.subnet]
}

module "worker" {
  count = var.worker_replicas
  source = "./worker"
  cluster_name = var.cluster_name
  image = var.image
  network_id = hcloud_network_subnet.subnet.id
  pool_name = "pool-1"
  datacenter = "nbg1"
  depends_on = [hcloud_network_subnet.subnet]
  worker_replicas = 1
}
