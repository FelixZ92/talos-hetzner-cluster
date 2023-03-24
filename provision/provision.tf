provider "hcloud" {
  token = var.hcloud_token
}

data "helm_template" "cilium" {
  chart      = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"

  name   = "cilium"
  values = [
    templatefile("cilium.yaml", {
      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
    })
  ]
}

resource "talos_machine_configuration_controlplane" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${hcloud_load_balancer.load_balancer.ipv4}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
  config_patches   = [
    templatefile("${path.module}/patches/common/kubelet-valid-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/common/machine-cert-sans.yaml", {
      public_loadbalancer_ip  = hcloud_load_balancer.load_balancer.ipv4
      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
    }),
    file("${path.module}/patches/common/rotate-certs.yaml"),
    file("${path.module}/patches/common/time-server.yaml"),
    templatefile("${path.module}/patches/controlplane/etcd-advertised-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/controlplane/extra-sans.yaml", {
      public_loadbalancer_ip  = hcloud_load_balancer.load_balancer.ipv4
      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
    }),
  ]
}

module "controlplane" {
  source = "./controlplane"

  cidr_offset             = 10
  cluster_name            = var.cluster_name
  image                   = var.image
  machine_secrets         = talos_machine_secrets.machine_secrets.machine_secrets
  network_id              = hcloud_network_subnet.subnet.id
  vpc_cidr                = var.vpc_cidr
  user_data               = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
}

resource "talos_machine_configuration_worker" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${hcloud_load_balancer.load_balancer.ipv4}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
  config_patches   = [
    templatefile("${path.module}/patches/common/kubelet-valid-subnets.yaml", {
      ip_range = var.vpc_cidr
    }),
    templatefile("${path.module}/patches/common/machine-cert-sans.yaml", {
      public_loadbalancer_ip  = hcloud_load_balancer.load_balancer.ipv4
      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
    }),
    file("${path.module}/patches/common/rotate-certs.yaml"),
    file("${path.module}/patches/common/time-server.yaml"),
  ]
}

# TODO: make multiple pools configurable
module "worker-pool-1" {
  source = "./worker"

  cidr_offset             = 20
  cluster_name            = var.cluster_name
  image                   = var.image
  machine_secrets         = talos_machine_secrets.machine_secrets.machine_secrets
  network_id              = hcloud_network_subnet.subnet.id
  pool_name               = "pool-1"
  vpc_cidr                = var.vpc_cidr
  user_data = talos_machine_configuration_worker.machineconfig_worker.machine_config
}
