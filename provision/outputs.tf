output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "worker_hosts" {
  value = module.worker.*.worker_hosts
}
