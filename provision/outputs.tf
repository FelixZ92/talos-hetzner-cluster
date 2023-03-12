output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "zipmap_test" {
  value = module.worker.zipmap_test
}