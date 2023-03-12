output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "worker_hosts" {
  value = module.worker-pool-1.worker_hosts.worker
}
