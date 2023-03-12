
resource "hcloud_placement_group" "control_plane" {
  name = "${var.cluster_name}-control-plane-pool"
  type = "spread"

  labels = {
    "cluster" = var.cluster_name
  }
}

resource "hcloud_server_network" "control_plane" {
  count     = var.control_plane_replicas
  server_id = element(hcloud_server.control_plane.*.id, count.index)
  subnet_id = var.network_id
}

resource "hcloud_server" "control_plane" {
  count              = var.control_plane_replicas
  name               = "${var.cluster_name}-control-plane-${count.index + 1}"
  server_type        = var.control_plane_type
  image              = var.image
  location           = var.datacenters[count.index]
  placement_group_id = hcloud_placement_group.control_plane.id
  user_data = var.control_plane_config
  labels = {
    "cluster" = var.cluster_name
    "role"                 = "controlplane"
  }
}
