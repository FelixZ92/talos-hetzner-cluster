provider "talos" {}

resource "talos_machine_secrets" "machine_secrets" {}

resource "talos_client_configuration" "talosconfig" {
  cluster_name    = var.cluster_name
  machine_secrets = talos_machine_secrets.machine_secrets.machine_secrets
  endpoints       = [for k, v in module.controlplane.controlplane_hosts.controlplanes : v.public_address]
}
#
#resource "talos_machine_configuration_apply" "cp_config_apply" {
#  talos_config          = talos_client_configuration.talosconfig.talos_config
#  machine_configuration = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
#  for_each              = module.controlplane.controlplane_hosts.controlplanes
#  endpoint              = each.value.public_address
#  node                  = each.value.public_address
#  config_patches = [
#    file("${path.module}/patches/common/rotate-certs.yaml"),
#    templatefile("${path.module}/patches/controlplane/extra-sans.yaml", {
#      public_loadbalancer_ip = hcloud_load_balancer.load_balancer.ipv4
#      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
#    }),
#    file("${path.module}/patches/controlplane/cloud-provider-hetzner.yaml"),
#    file("${path.module}/patches/controlplane/metrics-server.yaml"),
#  ]
#}
#
#resource "talos_machine_configuration_apply" "worker_config_apply" {
#  talos_config          = talos_client_configuration.talosconfig.talos_config
#  machine_configuration = talos_machine_configuration_worker.machineconfig_worker.machine_config
#  for_each              = module.worker-pool-1.worker_hosts.worker
#  endpoint              = each.value.public_address
#  node                  = each.value.public_address
#  config_patches = [
#    file("${path.module}/patches/common/rotate-certs.yaml"),
#  ]
#}
#

resource "time_sleep" "wait_30_for_server_boot" {
  depends_on = [module.controlplane]

  create_duration = "30s"
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on = [time_sleep.wait_30_for_api_server]
  talos_config = talos_client_configuration.talosconfig.talos_config
  endpoint     = hcloud_load_balancer.load_balancer.ipv4
  node         = [for k, v in module.controlplane.controlplane_hosts.controlplanes : v.private_address][0]
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  talos_config = talos_client_configuration.talosconfig.talos_config
  endpoint     = hcloud_load_balancer.load_balancer.ipv4
  node         = [for k, v in module.controlplane.controlplane_hosts.controlplanes : v.private_address][0]
}

