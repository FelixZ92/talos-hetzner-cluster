provider "hcloud" {}

module "controlplane" {
  source = "./controlplane"

  cidr_offset             = 10
  cluster_name            = var.cluster_name
  image                   = var.image
  loadbalancer_private_ip = hcloud_load_balancer_network.load_balancer.ip
  loadbalancer_public_ip  = hcloud_load_balancer.load_balancer.ipv4
  machine_secrets         = talos_machine_secrets.machine_secrets.machine_secrets
  network_id              = hcloud_network_subnet.subnet.id
  vpc_cidr                = var.vpc_cidr
  cilium_deployment       = data.helm_template.cilium.manifest
}

# TODO: make multiple pools configurable
module "worker-pool-1" {
  source = "./worker"

  cidr_offset             = 20
  cluster_name            = var.cluster_name
  image                   = var.image
  loadbalancer_private_ip = hcloud_load_balancer_network.load_balancer.ip
  loadbalancer_public_ip  = hcloud_load_balancer.load_balancer.ipv4
  machine_secrets         = talos_machine_secrets.machine_secrets.machine_secrets
  network_id              = hcloud_network_subnet.subnet.id
  pool_name               = "pool-1"
  vpc_cidr                = var.vpc_cidr
}
