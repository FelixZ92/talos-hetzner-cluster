resource "hcloud_network" "net" {
  name     = var.cluster_name
  ip_range = var.vpc_cidr
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.net.id
  type         = "server"
  network_zone = var.network_zone
  ip_range     = var.vpc_cidr
}
