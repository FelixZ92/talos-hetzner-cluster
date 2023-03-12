provider "talos" {}

resource "talos_machine_secrets" "machine_secrets" {}

resource "talos_machine_configuration_controlplane" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${module.controlplane.kubeapi_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_worker" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${module.controlplane.kubeapi_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

#resource "talos_client_configuration" "talosconfig" {
  #cluster_name    = var.cluster_name
  #machine_secrets = talos_machine_secrets.machine_secrets.machine_secrets
  #endpoints       = module.controlplane.controlplane_hosts.controlplanes.*.private_address
#}

#resource "talos_machine_configuration_apply" "cp_config_apply" {
#  talos_config          = talos_client_configuration.talosconfig.talos_config
#  machine_configuration = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
#  for_each              = module.controlplane.controlplane_hosts.controlplanes
#  endpoint              = each.value.private_address
#  node                  = each.value.name
#  config_patches = [
#    file("${path.module}/patches/common/rotate-certs.yaml"),
#    templatefile("${path.module}/patches/controlplane/extra-sans.yaml", {
#      loadbalancer_ip = module.controlplane.kubeapi_endpoint
#    }),
#    file("${path.module}/patches/controlplane/cloud-provider-hetzner.yaml"),
#    file("${path.module}/patches/controlplane/metrics-server.yaml"),
#  ]
#}

#
#resource "talos_machine_configuration_apply" "worker_config_apply" {
#  talos_config          = talos_client_configuration.talosconfig.talos_config
#  machine_configuration = talos_machine_configuration_worker.machineconfig_worker.machine_config
#  for_each              = module.worker.worker_hosts
#  endpoint              = each.private_address
#  node                  = each.private_address
#  config_patches = [
#    file("${path.module}/patches/common/rotate-certs.yaml"),
#  ]
#}
#
#resource "talos_machine_bootstrap" "bootstrap" {
#  talos_config = talos_client_configuration.talosconfig.talos_config
#  endpoint     = [for k, v in module.controlplane.controlplane_hosts.private_address : v][0]
#  node         = [for k, v in module.controlplane.controlplane_hosts.hostnames : v][0]
#}
#
#resource "talos_cluster_kubeconfig" "kubeconfig" {
#  talos_config = talos_client_configuration.talosconfig.talos_config
#  endpoint     = [for k, v in module.controlplane.controlplane_hosts.private_address : v][0]
#  node         = [for k, v in module.controlplane.controlplane_hosts.hostnames : v][0]
#}
#
