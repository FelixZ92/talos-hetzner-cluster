provider "hcloud" {}

module "controlplane" {
  source = "./controlplane"

  cluster_name = var.cluster_name
  image        = var.image
  network_id   = hcloud_network_subnet.subnet.id
  datacenters =  ["nbg1", "fsn1" , "hel1"]
}

# TODO: make multiple pools configurable
module "worker-pool-1" {
  source = "./worker"
  cluster_name = var.cluster_name
  image = var.image
  network_id = hcloud_network_subnet.subnet.id
  pool_name = "pool-1"
  datacenter = var.worker_datacenter
  worker_replicas = var.worker_replicas
  worker_type = var.worker_type
}
