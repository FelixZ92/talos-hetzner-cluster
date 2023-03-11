resource "hcloud_firewall" "cluster" {
  name = "${var.cluster_name}-fw"

  labels = {
    "cluster" = var.cluster_name
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
      var.ip_range,
    ]
  }

  rule {
    description = "allow all UDP inside cluster"
    direction   = "in"
    protocol    = "udp"
    port        = "any"
    source_ips  = [
      var.ip_range,
    ]
  }
}

resource "hcloud_firewall" "bastion" {
  name = "${var.cluster_name}-bastion-fw"

  labels = {
    "cluster" = var.cluster_name
  }

  apply_to {
    label_selector = "role=bastion"
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
    description = "allow SSH any"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = [
      "0.0.0.0/0",
    ]
  }
}
