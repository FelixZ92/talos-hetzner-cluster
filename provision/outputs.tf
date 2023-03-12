output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "worker_hosts" {
  value = module.worker-pool-1.worker_hosts.worker
}

output "machineconfig_controlplane" {
  value     = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
  sensitive = true
}

output "machineconfig_worker" {
  value     = talos_machine_configuration_worker.machineconfig_worker.machine_config
  sensitive = true
}

output "talosconfig" {
  value     = talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.kubeconfig.kube_config
  sensitive = true
}
