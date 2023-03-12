resource "hcloud_load_balancer_network" "load_balancer" {
  load_balancer_id        = hcloud_load_balancer.load_balancer.0.id
  subnet_id               = var.network_id
  ip                      = ""
  enable_public_interface = true
}

resource "hcloud_load_balancer" "load_balancer" {
  name               = "${var.cluster_name}-lb"
  load_balancer_type = var.lb_type
  network_zone       = var.network_zone

  labels = {
    "cluster" = var.cluster_name
    "role"    = "lb"
  }
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  label_selector   = "cluster=${var.cluster_name},role=controlplane"
  use_private_ip   = true
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}
