resource "hcloud_placement_group" "node_pool" {
  name = "${var.cluster_name}-${var.pool_name}"
  type = "spread"

  labels = {
    "cluster" = var.cluster_name
  }
}

module "instance" {
  source = "./instance"
  count = var.worker_replicas
  cluster_name = var.cluster_name
  datacenter = var.datacenter
  image = var.image
  loadbalancer_private_ip = var.loadbalancer_private_ip
  loadbalancer_public_ip = var.loadbalancer_public_ip
  machine_secrets = var.machine_secrets
  network_id = var.network_id
  placement_group = hcloud_placement_group.node_pool.id
  private_ip = cidrhost(var.vpc_cidr, var.cidr_offset + count.index)
  vpc_cidr = var.vpc_cidr
  pool_name   = var.pool_name
  worker_type = var.worker_type
  index = count.index
}
