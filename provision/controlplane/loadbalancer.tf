resource "hcloud_load_balancer_network" "load_balancer" {
  count = var.loadbalancer_count

  load_balancer_id        = hcloud_load_balancer.load_balancer.0.id
  subnet_id               = var.network_id
  ip = ""
  enable_public_interface = false
}

resource "hcloud_load_balancer" "load_balancer" {
  count = var.loadbalancer_count
  name               = "${var.cluster_name}-lb"
  load_balancer_type = var.lb_type
  network_zone = "eu-central"

  labels = {
    "cluster" = var.cluster_name
    "role"                 = "lb"
  }
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  count = var.loadbalancer_count

  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  label_selector   = "cluster=${var.cluster_name},role=controlplane"
  use_private_ip   = true

  depends_on = [
    hcloud_server_network.control_plane,
    hcloud_load_balancer_network.load_balancer
  ]
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  count = var.loadbalancer_count

  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}
