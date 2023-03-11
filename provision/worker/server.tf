resource "hcloud_placement_group" "node_pool" {
  name = "${var.cluster_name}-${var.pool_name}"
  type = "spread"

  labels = {
    "cluster" = var.cluster_name
  }
}

resource "hcloud_server_network" "control_plane" {
  count     = var.worker_replicas
  server_id = element(hcloud_server.worker.*.id, count.index)
  subnet_id = var.network_id
}

resource "hcloud_server" "worker" {
  count              = var.worker_replicas
  name               = "${var.cluster_name}-${var.pool_name}-worker-${count.index + 1}"
  server_type        = var.worker_type
  image              = var.image
  datacenter = var.datacenter
  placement_group_id = hcloud_placement_group.node_pool.id
  labels             = {
    "cluster" = var.cluster_name
    "role"    = "worker"
    "pool"    = var.pool_name
  }
}
