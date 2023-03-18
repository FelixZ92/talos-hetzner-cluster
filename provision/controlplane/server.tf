resource "hcloud_placement_group" "control_plane" {
  name = "${var.cluster_name}-control-plane-pool"
  type = "spread"

  labels = {
    "cluster" = var.cluster_name
  }
}

module "instance" {
  source = "./instance"
  count = var.control_plane_replicas
  cluster_name = var.cluster_name
  control_plane_type = var.control_plane_type
  datacenter = var.datacenters[count.index]
  image = var.image
  loadbalancer_private_ip = var.loadbalancer_private_ip
  loadbalancer_public_ip = var.loadbalancer_public_ip
  machine_secrets = var.machine_secrets
  network_id = var.network_id
  placement_group = hcloud_placement_group.control_plane.id
  private_ip = cidrhost(var.vpc_cidr, var.cidr_offset + count.index)
  vpc_cidr = var.vpc_cidr
  index = count.index
}
