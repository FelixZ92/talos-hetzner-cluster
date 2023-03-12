output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "zipmap_test" {
  value = module.worker.*.zipmap_test
}

output "worker_hosts" {
  value = module.worker.*.worker_hosts
}


output "zipmap_test2" {
  value = module.controlplane.*.zipmap_test2
}
