output "worker_hosts" {
  value = zipmap(hcloud_server.worker.*.name, hcloud_server_network.worker.*.ip)
}

output "zipmap_test" {
  value = {
    workers = zipmap(hcloud_server.worker.*.name, hcloud_server_network.worker.*.ip)
  }
}
