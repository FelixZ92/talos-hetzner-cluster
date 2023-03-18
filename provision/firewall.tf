resource "hcloud_firewall" "allow_all_in_private_network" {
  name = "${var.cluster_name}-allow-all-in-private-network"

  labels = {
    "cluster" = var.cluster_name
    "role" = "all"
  }

  apply_to {
    label_selector = "cluster=${var.cluster_name}"
  }

  rule {
    description = "allow ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = [
      "0.0.0.0/0",
    ]
  }

  rule {
    description = "allow all TCP inside cluster"
    direction   = "in"
    protocol    = "tcp"
    port        = "any"
    source_ips  = [
      var.vpc_cidr,
    ]
  }

  rule {
    description = "allow all UDP inside cluster"
    direction   = "in"
    protocol    = "udp"
    port        = "any"
    source_ips  = [
      var.vpc_cidr,
    ]
  }
}

resource "hcloud_firewall" "allow_apid_kubeapi" {
  name = "${var.cluster_name}-allow-apid-and-kubeapi"

  labels = {
    "cluster" = var.cluster_name
    "role" = "controlplane"
  }

  apply_to {
    label_selector = "cluster=${var.cluster_name},role=controlplane"
  }

  rule {
    description = "allow apid"
    direction   = "in"
    protocol    = "tcp"
    port        = "50000"
    source_ips  = [
      "0.0.0.0/0",
    ]
  }

  rule {
    description = "allow kubeapi"
    direction   = "in"
    protocol    = "tcp"
    port        = "6443"
    source_ips  = [
      "0.0.0.0/0",
    ]
  }
}
