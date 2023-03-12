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

  rule {
    description = "allow trustd"
    direction   = "in"
    protocol    = "tcp"
    port        = "50001"
    source_ips  = [
      "0.0.0.0/0",
    ]
  }
}

resource "hcloud_firewall" "controlplane" {
  name = "${var.cluster_name}-api-fw"

  labels = {
    "cluster" = var.cluster_name
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
