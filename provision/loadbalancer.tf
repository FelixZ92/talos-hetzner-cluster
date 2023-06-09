resource "hcloud_load_balancer_network" "load_balancer" {
  load_balancer_id        = hcloud_load_balancer.load_balancer.id
  subnet_id               = hcloud_network_subnet.subnet.id
  ip                      = cidrhost(var.vpc_cidr, 2)
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
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  label_selector   = "cluster=${var.cluster_name},role=controlplane"
  use_private_ip   = true
  depends_on       = [hcloud_load_balancer_network.load_balancer]
}

resource "hcloud_load_balancer_service" "k8s_api_server" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_service" "talos_api_server" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "tcp"
  listen_port      = 50000
  destination_port = 50000
}
