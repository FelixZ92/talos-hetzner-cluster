resource "hcloud_server_network" "control_plane" {
  server_id = hcloud_server.control_plane.id
  subnet_id = var.network_id
  ip        = var.private_ip
}

resource "hcloud_primary_ip" "primary_ip" {
  name          = "${var.cluster_name}-control-plane-${var.index}"
  type          = "ipv4"
  assignee_type = "server"
  datacenter    = var.datacenter
  auto_delete   = false
  labels        = {
    "cluster" = var.cluster_name
    "role"    = "controlplane"
  }
}

resource "talos_machine_configuration_controlplane" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.loadbalancer_public_ip}:6443"
  machine_secrets  = var.machine_secrets
  config_patches   = [
    file("${path.module}/patches/common/interfaces.yaml"),
    templatefile("${path.module}/patches/common/kubelet-valid-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/common/machine-cert-sans.yaml", {
      public_loadbalancer_ip  = var.loadbalancer_public_ip
      private_loadbalancer_ip = var.loadbalancer_private_ip
      public_ip               = hcloud_primary_ip.primary_ip.ip_address
      private_ip              = var.private_ip
    }),
    file("${path.module}/patches/common/rotate-certs.yaml"),
    file("${path.module}/patches/controlplane/cloud-provider-hetzner.yaml"),
    templatefile("${path.module}/patches/controlplane/etcd-advertised-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/controlplane/extra-sans.yaml", {
      public_loadbalancer_ip  = var.loadbalancer_public_ip
      private_loadbalancer_ip = var.loadbalancer_private_ip
      public_ip               = hcloud_primary_ip.primary_ip.ip_address
      private_ip              = var.private_ip
    }),
    file("${path.module}/patches/controlplane/metrics-server.yaml"),
  ]
}

resource "hcloud_server" "control_plane" {
  name               = "${var.cluster_name}-control-plane-${var.index}"
  server_type        = var.control_plane_type
  image              = var.image
  datacenter         = var.datacenter
  placement_group_id = var.placement_group
  user_data          = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
  labels             = {
    "cluster" = var.cluster_name
    "role"    = "controlplane"
  }

  public_net {
    ipv4 = hcloud_primary_ip.primary_ip.id
  }

  lifecycle {
    ignore_changes = [
      network,
      image,
      server_type,
      user_data,
      ssh_keys,
    ]
  }
}
