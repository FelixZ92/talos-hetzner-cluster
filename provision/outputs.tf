output "controlplane_hosts" {
  value = module.controlplane.*.controlplane_hosts
}

output "zipmap_test" {
  value = module.controlplane.kubeapi_endpoint
}
