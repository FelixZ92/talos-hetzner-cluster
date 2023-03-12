output "controlplane_hosts" {
  value = module.controlplane.*.test
}

output "zipmap_test" {
  value = module.worker.*.zipmap_test
}

output "worker_hosts" {
  value = module.worker.*.worker_hosts
}
