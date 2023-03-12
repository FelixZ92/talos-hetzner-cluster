output "worker_hosts" {
  value = zipmap(hcloud_server.worker.*.name, hcloud_server_network.worker.*.ip)
}

output "zipmap_test" {
  value = {
    for i, w in hcloud_server.worker : w.name => hcloud_server_network.worker[i].ip
  }
}
