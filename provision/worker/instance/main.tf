resource "hcloud_server_network" "worker" {
  server_id = hcloud_server.worker.id
  subnet_id = var.network_id
  ip        = var.private_ip
}

resource "hcloud_primary_ip" "primary_ip" {
  name          = "${var.cluster_name}-${var.pool_name}-worker"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels        = {
    "cluster" = var.cluster_name
    "role"    = "worker"
  }
}

resource "talos_machine_configuration_worker" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.loadbalancer_public_ip}:6443"
  machine_secrets  = var.machine_secrets
  config_patches = [
    file("${path.module}/patches/common/interfaces.yaml"),
    templatefile("${path.module}/patches/common/kubelet-valid-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/common/machine-cert-sans.yaml", {
      public_loadbalancer_ip = var.loadbalancer_public_ip
      private_loadbalancer_ip = var.loadbalancer_private_ip
      public_ip = hcloud_primary_ip.primary_ip.ip
      private_ip = var.private_ip
    }),
    templatefile("${path.module}/patches/common/node-ip.yaml", {
      private_ip = var.private_ip
    }),
    file("${path.module}/patches/common/rotate-certs.yaml"),
  ]
}

resource "hcloud_server" "worker" {
  name               = "${var.cluster_name}-${var.pool_name}-worker"
  server_type        = var.worker_type
  image              = var.image
  location           = var.datacenter
  placement_group_id = var.placement_group
  user_data          = talos_machine_configuration_worker.machineconfig_worker.machine_config
  labels             = {
    "cluster" = var.cluster_name
    "role"    = "worker"
  }

  public_net {
    ipv4 = hcloud_primary_ip.primary_ip.ip
  }
}
