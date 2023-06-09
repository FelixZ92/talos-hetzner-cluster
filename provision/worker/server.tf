resource "hcloud_placement_group" "node_pool" {
  name = "${var.cluster_name}-${var.pool_name}"
  type = "spread"

  labels = {
    "cluster" = var.cluster_name
  }
}

resource "hcloud_server_network" "worker" {
  count     = var.worker_replicas
  server_id = element(hcloud_server.worker.*.id, count.index)
  subnet_id = var.network_id
  ip        = cidrhost(var.vpc_cidr, var.cidr_offset + count.index)
}

resource "hcloud_server" "worker" {
  count = var.worker_replicas
  name               = "${var.cluster_name}-${var.pool_name}-worker-${count.index}"
  server_type        = var.worker_type
  image              = var.image
  datacenter         = var.datacenter
  placement_group_id = hcloud_placement_group.node_pool.id
  user_data          = var.user_data
  labels             = {
    "cluster" = var.cluster_name
    "role"    = "worker"
    "pool"    = var.pool_name
  }

  lifecycle {
    ignore_changes = [
      image,
      server_type,
      user_data,
      ssh_keys,
    ]
  }
}
