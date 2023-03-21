output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "worker_hosts" {
  value = module.worker-pool-1.worker_hosts.worker
}

output "talosconfig" {
  value     = talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.kubeconfig.kube_config
  sensitive = true
}

output "cilium" {
  value = data.helm_template.cilium.manifest
}

output "cilium_yamls" {
  value = data.helm_template.cilium.manifests
}